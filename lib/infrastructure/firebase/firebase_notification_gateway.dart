import 'package:firebase_messaging/firebase_messaging.dart';

import '../../core/notifications/notification_gateway.dart';

final class FirebaseNotificationGateway implements NotificationGateway {
  FirebaseNotificationGateway(this._messaging);

  final FirebaseMessaging _messaging;

  @override
  Future<void> requestPermission() async {
    await _messaging.requestPermission();
  }

  @override
  Stream<String> get tokenChanges => _messaging.onTokenRefresh;
}
