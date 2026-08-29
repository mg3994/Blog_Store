import 'package:blogstore/core/sync/outbox_entry.dart';
import 'package:blogstore/core/sync/outbox_repository.dart';
import 'package:blogstore/infrastructure/database/drift/app_database.dart';
import 'package:drift/drift.dart';

class DriftOutboxRepository implements OutboxRepository {
  final AppDatabase _db;

  DriftOutboxRepository(this._db);

  @override
  Future<void> enqueue(OutboxEntryItem entry) async {
    await _db.into(_db.outboxEntries).insertOnConflictUpdate(
          OutboxEntriesCompanion(
            id: Value(entry.id),
            idempotencyKey: Value(entry.idempotencyKey),
            endpoint: Value(entry.endpoint),
            httpMethod: Value(entry.httpMethod),
            payloadJson: Value(entry.payloadJson),
            status: Value(entry.status.name),
            retryCount: Value(entry.retryCount),
            lastError: Value(entry.lastError),
            createdAt: Value(entry.createdAt),
            updatedAt: Value(entry.updatedAt),
          ),
        );
  }

  @override
  Future<List<OutboxEntryItem>> getPendingEntries() async {
    final query = _db.select(_db.outboxEntries)
      ..where((tbl) => tbl.status.equals('pending'))
      ..orderBy([(tbl) => OrderingTerm.asc(tbl.createdAt)]);

    final rows = await query.get();
    return rows.map((row) => OutboxEntryItem(
      id: row.id,
      idempotencyKey: row.idempotencyKey,
      endpoint: row.endpoint,
      httpMethod: row.httpMethod,
      payloadJson: row.payloadJson,
      status: OutboxStatus.values.firstWhere(
        (e) => e.name == row.status,
        orElse: () => OutboxStatus.pending,
      ),
      retryCount: row.retryCount,
      lastError: row.lastError,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    )).toList();
  }

  @override
  Future<void> updateEntryStatus(
    String id,
    OutboxStatus status, {
    int? retryCount,
    String? lastError,
  }) async {
    await (_db.update(_db.outboxEntries)..where((tbl) => tbl.id.equals(id)))
        .write(
      OutboxEntriesCompanion(
        status: Value(status.name),
        retryCount: retryCount != null ? Value(retryCount) : const Value.absent(),
        lastError: lastError != null ? Value(lastError) : const Value.absent(),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<void> deleteEntry(String id) async {
    await (_db.delete(_db.outboxEntries)..where((tbl) => tbl.id.equals(id))).go();
  }

  @override
  Future<DateTime?> getWatermark(String featureTag) async {
    final query = _db.select(_db.syncWatermarks)
      ..where((tbl) => tbl.featureTag.equals(featureTag));
    final row = await query.getSingleOrNull();
    return row?.lastSyncedAt;
  }

  @override
  Future<void> setWatermark(String featureTag, DateTime timestamp) async {
    await _db.into(_db.syncWatermarks).insertOnConflictUpdate(
          SyncWatermarksCompanion(
            featureTag: Value(featureTag),
            lastSyncedAt: Value(timestamp),
          ),
        );
  }
}
