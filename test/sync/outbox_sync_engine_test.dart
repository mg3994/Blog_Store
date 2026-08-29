import 'dart:async';
import 'dart:math';

import '../../lib/core/sync/outbox_entry.dart';
import '../../lib/core/sync/outbox_repository.dart';
import '../../lib/core/sync/outbox_sync_engine.dart';
import '../../lib/core/sync/connectivity_sync_service.dart';

class InMemoryOutboxRepository implements OutboxRepository {
  final Map<String, OutboxEntryItem> entries = {};
  final Map<String, DateTime> watermarks = {};

  @override
  Future<void> enqueue(OutboxEntryItem entry) async {
    entries[entry.id] = entry;
  }

  @override
  Future<List<OutboxEntryItem>> getPendingEntries() async {
    final list = entries.values
        .where((e) => e.status == OutboxStatus.pending)
        .toList();
    list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return list;
  }

  @override
  Future<void> updateEntryStatus(
    String id,
    OutboxStatus status, {
    int? retryCount,
    String? lastError,
  }) async {
    if (entries.containsKey(id)) {
      final existing = entries[id]!;
      entries[id] = existing.copyWith(
        status: status,
        retryCount: retryCount ?? existing.retryCount,
        lastError: lastError ?? existing.lastError,
        updatedAt: DateTime.now(),
      );
    }
  }

  @override
  Future<void> deleteEntry(String id) async {
    entries.remove(id);
  }

  @override
  Future<DateTime?> getWatermark(String featureTag) async {
    return watermarks[featureTag];
  }

  @override
  Future<void> setWatermark(String featureTag, DateTime timestamp) async {
    watermarks[featureTag] = timestamp;
  }
}

class FakeNetworkDispatcher implements NetworkDispatcher {
  bool shouldSucceed = true;
  final List<Map<String, String>> sentRequests = [];

  @override
  Future<bool> sendRequest({
    required String endpoint,
    required String method,
    required String payloadJson,
    required String idempotencyKey,
  }) async {
    sentRequests.add({
      'endpoint': endpoint,
      'method': method,
      'payloadJson': payloadJson,
      'idempotencyKey': idempotencyKey,
    });
    return shouldSucceed;
  }
}

class FakeConnectivityService implements ConnectivityService {
  final StreamController<bool> _controller = StreamController<bool>.broadcast();
  bool _current = true;

  void emit(bool connected) {
    _current = connected;
    _controller.add(connected);
  }

  @override
  Stream<bool> get onConnectivityChanged => _controller.stream;

  @override
  Future<bool> isConnected() async => _current;

  void dispose() {
    _controller.close();
  }
}

Future<void> main() async {
  print('Running Offline Sync Engine tests...');

  final repository = InMemoryOutboxRepository();
  final networkDispatcher = FakeNetworkDispatcher();
  final syncEngine = OutboxSyncEngine(
    repository: repository,
    networkDispatcher: networkDispatcher,
    random: Random(42),
  );

  // Test 1: Enqueue & Retrieve Pending Entry
  {
    final now = DateTime.now();
    final entry = OutboxEntryItem(
      id: '1',
      idempotencyKey: 'idempotency-123',
      endpoint: '/api/orders',
      httpMethod: 'POST',
      payloadJson: '{"orderId":"abc"}',
      createdAt: now,
      updatedAt: now,
    );

    await repository.enqueue(entry);
    final pending = await repository.getPendingEntries();
    assert(pending.length == 1, 'Expected 1 pending entry');
    assert(pending.first.idempotencyKey == 'idempotency-123', 'Idempotency key mismatch');
    print('✓ Test 1 Passed: Enqueue and retrieve pending entry');
  }

  // Test 2: Process Outbox deletes row ONLY on server confirmation
  {
    networkDispatcher.shouldSucceed = true;
    final processed = await syncEngine.processOutbox();
    assert(processed == 1, 'Expected 1 processed entry');
    assert(!repository.entries.containsKey('1'), 'Entry should be deleted on server confirmation');
    assert(networkDispatcher.sentRequests.first['idempotencyKey'] == 'idempotency-123', 'Header mismatch');
    print('✓ Test 2 Passed: Process outbox deletes row ONLY on server confirmation');
  }

  // Test 3: Process Outbox retains row on failure and increments retry count
  {
    final now = DateTime.now();
    final entry = OutboxEntryItem(
      id: '2',
      idempotencyKey: 'key-2',
      endpoint: '/api/cart',
      httpMethod: 'POST',
      payloadJson: '{"item":"widget"}',
      createdAt: now,
      updatedAt: now,
    );

    await repository.enqueue(entry);
    networkDispatcher.shouldSucceed = false;

    final processed = await syncEngine.processOutbox();
    assert(processed == 0, 'Expected 0 processed entries on failure');
    assert(repository.entries.containsKey('2'), 'Entry should be retained on failure');
    final retained = repository.entries['2']!;
    assert(retained.status == OutboxStatus.pending, 'Status should return to pending');
    assert(retained.retryCount == 1, 'Retry count should be 1');
    print('✓ Test 3 Passed: Process outbox retains row on failure and increments retry count');
  }

  // Test 4: Exponential Backoff with Jitter Calculation
  {
    final delay0 = syncEngine.calculateBackoffDelay(0);
    final delay1 = syncEngine.calculateBackoffDelay(1);
    final delay2 = syncEngine.calculateBackoffDelay(2);

    assert(delay0.inMilliseconds >= 800 && delay0.inMilliseconds <= 1200, 'Delay 0 out of jitter bounds');
    assert(delay1.inMilliseconds >= 1600 && delay1.inMilliseconds <= 2400, 'Delay 1 out of jitter bounds');
    assert(delay2.inMilliseconds >= 3200 && delay2.inMilliseconds <= 4800, 'Delay 2 out of jitter bounds');
    print('✓ Test 4 Passed: Exponential backoff with jitter calculation bounds');
  }

  // Test 5: Watermark Sync Storage and Retrieval
  {
    final tag = 'catalog_sync';
    final syncTime = DateTime(2026, 3, 30, 12, 0, 0);

    await repository.setWatermark(tag, syncTime);
    final retrieved = await repository.getWatermark(tag);
    assert(retrieved == syncTime, 'Watermark timestamp mismatch');
    print('✓ Test 5 Passed: Watermark sync storage and retrieval');
  }

  // Test 6: Last-Write-Wins (LWW) Conflict Resolution
  {
    final earlier = DateTime(2026, 3, 30, 10, 0, 0);
    final later = DateTime(2026, 3, 30, 11, 0, 0);

    assert(
      OutboxSyncEngine.resolveLastWriteWins(
        localUpdatedAt: later,
        serverUpdatedAt: earlier,
      ) == true,
      'LWW local newer failed',
    );

    assert(
      OutboxSyncEngine.resolveLastWriteWins(
        localUpdatedAt: earlier,
        serverUpdatedAt: later,
      ) == false,
      'LWW server newer failed',
    );
    print('✓ Test 6 Passed: Last-Write-Wins conflict resolution logic');
  }

  // Test 7: ConnectivitySyncService triggers sync on connection restored
  {
    final fakeConnectivity = FakeConnectivityService();
    final syncService = ConnectivitySyncService(
      connectivityService: fakeConnectivity,
      syncEngine: syncEngine,
    );

    final entry = OutboxEntryItem(
      id: '3',
      idempotencyKey: 'key-3',
      endpoint: '/api/pay',
      httpMethod: 'POST',
      payloadJson: '{"amount":100}',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await repository.enqueue(entry);
    networkDispatcher.shouldSucceed = true;

    syncService.startListening();
    fakeConnectivity.emit(true);

    await Future.delayed(Duration(milliseconds: 50));
    assert(!repository.entries.containsKey('3'), 'Entry 3 should be synced on reconnect');
    fakeConnectivity.dispose();
    print('✓ Test 7 Passed: ConnectivitySyncService auto sync on reconnect');
  }

  print('\nAll 7 Offline-First Architecture Tests PASSED SUCCESSFULLY!');
}
