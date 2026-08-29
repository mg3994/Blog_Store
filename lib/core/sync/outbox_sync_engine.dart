import 'dart:math';
import 'outbox_entry.dart';
import 'outbox_repository.dart';

abstract class NetworkDispatcher {
  Future<bool> sendRequest({
    required String endpoint,
    required String method,
    required String payloadJson,
    required String idempotencyKey,
  });
}

class OutboxSyncEngine {
  final OutboxRepository _repository;
  final NetworkDispatcher _networkDispatcher;
  final Random _random;

  OutboxSyncEngine({
    required OutboxRepository repository,
    required NetworkDispatcher networkDispatcher,
    Random? random,
  })  : _repository = repository,
        _networkDispatcher = networkDispatcher,
        _random = random ?? Random();

  /// Calculates exponential backoff duration with jitter for a given retry attempt.
  /// Base duration: 1 second, multiplier: 2^attempt, jitter: ±20%.
  Duration calculateBackoffDelay(int retryCount, {Duration baseDelay = const Duration(seconds: 1)}) {
    final exponentialMs = baseDelay.inMilliseconds * pow(2, retryCount).toInt();
    final jitterPercentage = (_random.nextDouble() * 0.4) - 0.2; // -20% to +20%
    final finalMs = (exponentialMs * (1 + jitterPercentage)).round();
    return Duration(milliseconds: max(100, finalMs));
  }

  /// Processes all pending outbox entries sequentially.
  /// Deletes row ONLY after confirmation (isSuccess).
  Future<int> processOutbox() async {
    final pendingEntries = await _repository.getPendingEntries();
    int processedCount = 0;

    for (final entry in pendingEntries) {
      await _repository.updateEntryStatus(entry.id, OutboxStatus.inFlight);

      bool isSuccess = false;
      String? errorMessage;

      try {
        isSuccess = await _networkDispatcher.sendRequest(
          endpoint: entry.endpoint,
          method: entry.httpMethod,
          payloadJson: entry.payloadJson,
          idempotencyKey: entry.idempotencyKey,
        );
      } catch (e) {
        isSuccess = false;
        errorMessage = e.toString();
      }

      if (isSuccess) {
        // ONLY delete the row once the server confirms.
        await _repository.deleteEntry(entry.id);
        processedCount++;
      } else {
        // Not confirmed. Leave row in outbox with updated retry count & status.
        final nextRetryCount = entry.retryCount + 1;
        await _repository.updateEntryStatus(
          entry.id,
          OutboxStatus.pending,
          retryCount: nextRetryCount,
          lastError: errorMessage ?? 'Network request failed or server rejected',
        );
      }
    }

    return processedCount;
  }

  /// Conflict Resolution: Last-Write-Wins (LWW)
  /// Returns true if local data should overwrite server data based on updated_at timestamps.
  static bool resolveLastWriteWins({
    required DateTime localUpdatedAt,
    required DateTime serverUpdatedAt,
  }) {
    return localUpdatedAt.isAfter(serverUpdatedAt);
  }
}
