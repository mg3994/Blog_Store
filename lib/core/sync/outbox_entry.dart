enum OutboxStatus { pending, inFlight, failed }

class OutboxEntryItem {
  final String id;
  final String idempotencyKey;
  final String endpoint;
  final String httpMethod;
  final String payloadJson;
  final OutboxStatus status;
  final int retryCount;
  final String? lastError;
  final DateTime createdAt;
  final DateTime updatedAt;

  const OutboxEntryItem({
    required this.id,
    required this.idempotencyKey,
    required this.endpoint,
    required this.httpMethod,
    required this.payloadJson,
    this.status = OutboxStatus.pending,
    this.retryCount = 0,
    this.lastError,
    required this.createdAt,
    required this.updatedAt,
  });

  OutboxEntryItem copyWith({
    String? id,
    String? idempotencyKey,
    String? endpoint,
    String? httpMethod,
    String? payloadJson,
    OutboxStatus? status,
    int? retryCount,
    String? lastError,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OutboxEntryItem(
      id: id ?? this.id,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      endpoint: endpoint ?? this.endpoint,
      httpMethod: httpMethod ?? this.httpMethod,
      payloadJson: payloadJson ?? this.payloadJson,
      status: status ?? this.status,
      retryCount: retryCount ?? this.retryCount,
      lastError: lastError ?? this.lastError,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class SyncWatermarkItem {
  final String featureTag;
  final DateTime lastSyncedAt;

  const SyncWatermarkItem({
    required this.featureTag,
    required this.lastSyncedAt,
  });
}
