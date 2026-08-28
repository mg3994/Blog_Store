import 'package:firebase_messaging/firebase_messaging.dart';

typedef BackgroundMessageHandler = Future<void> Function(RemoteMessage message);

abstract interface class NotificationGateway {
  Future<bool> isSupported();

  Future<bool> requestPermission();

  Future<String?> getToken();

  Stream<String> get tokenChanges;

  Future<void> deleteToken();

  Stream<RemoteMessage> get onForegroundMessage;

  Stream<RemoteMessage> get onNotificationOpened;

  Future<RemoteMessage?> getInitialMessage();

  Future<void> subscribeToTopic(String topic);

  Future<void> unsubscribeFromTopic(String topic);

  Future<void> setForegroundPresentationOptions({
    bool alert = true,
    bool badge = true,
    bool sound = true,
  });

  Future<void> registerBackgroundHandler(BackgroundMessageHandler handler);
}
