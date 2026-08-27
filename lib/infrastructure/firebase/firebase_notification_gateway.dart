import 'package:firebase_messaging/firebase_messaging.dart';

import '../../core/notifications/notification_gateway.dart';

final class FirebaseNotificationGateway implements NotificationGateway {
  FirebaseNotificationGateway(this._messaging);

  final FirebaseMessaging _messaging;

  @override
  Future<void> requestPermission() async {
    // Prevents calling JS interop on unsupported web browsers/contexts
    if (await _messaging.isSupported()) {
      await _messaging.requestPermission();
    }
  }

  @override
  Stream<String> get tokenChanges async* {
    if (await _messaging.isSupported()) {
      yield* _messaging.onTokenRefresh;
    }
  }
}
