import 'dart:async';
import 'outbox_sync_engine.dart';

abstract class ConnectivityService {
  Stream<bool> get onConnectivityChanged;
  Future<bool> isConnected();
}

class ConnectivitySyncService {
  final ConnectivityService _connectivityService;
  final OutboxSyncEngine _syncEngine;

  ConnectivitySyncService({
    required ConnectivityService connectivityService,
    required OutboxSyncEngine syncEngine,
  })  : _connectivityService = connectivityService,
        _syncEngine = syncEngine;

  /// Starts listening to network connectivity restoration events.
  /// When connectivity becomes available (true), triggers outbox sync processing.
  void startListening() {
    _connectivityService.onConnectivityChanged.listen((isConnected) {
      if (isConnected) {
        _syncEngine.processOutbox();
      }
    });
  }

  /// Triggers a manual sync if network is currently connected.
  Future<int> syncIfConnected() async {
    final connected = await _connectivityService.isConnected();
    if (connected) {
      return await _syncEngine.processOutbox();
    }
    return 0;
  }
}
