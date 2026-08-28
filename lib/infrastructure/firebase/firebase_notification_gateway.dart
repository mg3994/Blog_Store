import 'package:firebase_messaging/firebase_messaging.dart';

import '../../core/notifications/notification_gateway.dart'
    show NotificationGateway;

final class FirebaseNotificationGateway implements NotificationGateway {
  FirebaseNotificationGateway(this._messaging, {this.vapidKey});

  final FirebaseMessaging _messaging;
  final String? vapidKey;

  @override
  Future<bool> isSupported() => _messaging.isSupported();

  @override
  Future<bool> requestPermission() async {
    if (!await isSupported()) return false;

    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  @override
  Future<String?> getToken() async {
    if (!await isSupported()) return null;

    try {
      return await _messaging.getToken(vapidKey: vapidKey);
    } catch (_) {
      // Handles APNs delay on iOS or missing browser permissions on web
      return null;
    }
  }

  @override
  Stream<String> get tokenChanges async* {
    if (!await isSupported()) return;

    final token = await getToken();
    if (token != null) yield token;

    yield* _messaging.onTokenRefresh;
  }

  @override
  Future<void> deleteToken() async {
    if (!await isSupported()) return;
    await _messaging.deleteToken();
  }

  @override
  Stream<RemoteMessage> get onForegroundMessage => FirebaseMessaging.onMessage;

  @override
  Stream<RemoteMessage> get onNotificationOpened =>
      FirebaseMessaging.onMessageOpenedApp;

  @override
  Future<RemoteMessage?> getInitialMessage() async {
    if (!await isSupported()) return null;
    return _messaging.getInitialMessage();
  }

  @override
  Future<void> subscribeToTopic(String topic) async {
    if (!await isSupported()) return;
    await _messaging.subscribeToTopic(topic);
  }

  @override
  Future<void> unsubscribeFromTopic(String topic) async {
    if (!await isSupported()) return;
    await _messaging.unsubscribeFromTopic(topic);
  }

  @override
  Future<void> setForegroundPresentationOptions({
    bool alert = true,
    bool badge = true,
    bool sound = true,
  }) async {
    if (!await isSupported()) return;

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: alert,
      badge: badge,
      sound: sound,
    );
  }

  @override
  Future<void> registerBackgroundHandler(
    BackgroundMessageHandler handler,
  ) async {
    if (!await isSupported()) return;
    FirebaseMessaging.onBackgroundMessage(handler);
  }
}
