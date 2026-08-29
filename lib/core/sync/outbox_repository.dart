import 'outbox_entry.dart';

abstract class OutboxRepository {
  Future<void> enqueue(OutboxEntryItem entry);
  Future<List<OutboxEntryItem>> getPendingEntries();
  Future<void> updateEntryStatus(
    String id,
    OutboxStatus status, {
    int? retryCount,
    String? lastError,
  });
  Future<void> deleteEntry(String id);
  Future<DateTime?> getWatermark(String featureTag);
  Future<void> setWatermark(String featureTag, DateTime timestamp);
}
