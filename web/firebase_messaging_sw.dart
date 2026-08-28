import 'dart:js_interop';

import 'package:blogstore/firebase_web_config.dart';

@JS('importScripts')
external void importScripts(JSString script1, JSString script2);

@JS('firebase.initializeApp')
external JSObject initializeApp(JSObject options);

@JS('firebase.messaging')
external FirebaseMessaging messaging();

@JS('firebase.messaging.isSupported')
external JSPromise<JSBoolean> isSupported();

@JS('console.log')
external void consoleLog(JSAny? value);

@JS('self')
external ServiceWorkerGlobalScope get self;

@JS()
@staticInterop
class ServiceWorkerGlobalScope {}

extension ServiceWorkerGlobalScopeExtension on ServiceWorkerGlobalScope {
  external ServiceWorkerRegistration get registration;

  external JSAny? addEventListener(JSString type, JSFunction listener);

  external JSAny? get clients;
}

@JS()
@staticInterop
class ServiceWorkerRegistration {}

extension ServiceWorkerRegistrationExtension on ServiceWorkerRegistration {
  external JSPromise<JSAny?> showNotification(JSString title, JSObject options);
}

@JS()
@staticInterop
class FirebaseMessaging {}

extension FirebaseMessagingExtension on FirebaseMessaging {
  external void onBackgroundMessage(JSFunction callback);

  external void setDeliveryMetricsExportedToBigQuery(bool enabled);
}

void main() {
  //
  // Firebase JS SDK
  //
  importScripts(
    'https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js'.toJS,
    'https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js'
        .toJS,
  );

  //
  // Service worker install
  //
  self.addEventListener(
    'install'.toJS,
    ((JSObject event) {
      consoleLog(self);
      consoleLog(event);
    }).toJS,
  );

  //
  // Notification click
  //
  self.addEventListener(
    'notificationclick'.toJS,
    ((JSObject event) {
      final notification = event.getProperty<JSObject?>('notification'.toJS);

      notification?.callMethod<void>('close'.toJS);

      final clients = self.getProperty<JSObject?>('clients'.toJS);

      if (clients == null) {
        return;
      }

      final matchAll = clients.callMethod<JSPromise<JSArray>>(
        'matchAll'.toJS,
        {'type': 'window'.toJS, 'includeUncontrolled': true.toJS}.jsify(),
      );

      event.callMethod<void>('waitUntil'.toJS, matchAll);

      matchAll.toDart.then((clientList) {
        for (final client in clientList.toDart) {
          final focused = client.getProperty<JSBoolean?>('focused'.toJS);

          if (focused?.toDart != true) {
            client.callMethod<JSPromise<JSAny?>>('focus'.toJS);
            break;
          }
        }
      });
    }).toJS,
  );

  //
  // Firebase configuration
  //
  final options =
      <String, JSAny?>{
            'apiKey': FirebaseWebConfig.apiKey,
            'appId': FirebaseWebConfig.appId,
            'messagingSenderId': FirebaseWebConfig.messagingSenderId,
            'projectId': FirebaseWebConfig.projectId,
            'authDomain': FirebaseWebConfig.authDomain,
            'databaseURL': FirebaseWebConfig.databaseURL,
            'storageBucket': FirebaseWebConfig.storageBucket,
            'measurementId': FirebaseWebConfig.measurementId,
          }.jsify()
          as JSObject;

  final app = initializeApp(options);

  //
  // Check browser support
  //
  isSupported().toDart.then((supported) {
    if (!supported) {
      return;
    }

    //
    // Firebase Messaging
    //
    final messagingInstance = messaging();

    //
    // Equivalent to:
    //
    // experimentalSetDeliveryMetricsExportedToBigQueryEnabled(
    //   messaging,
    //   true,
    // );
    //
    messagingInstance.setDeliveryMetricsExportedToBigQuery(true);

    //
    // Background message
    //
    messagingInstance.onBackgroundMessage(
      ((JSAny? rawMessage) {
        if (rawMessage == null) {
          return;
        }

        final message = rawMessage as JSObject;

        final notification = message.getProperty<JSObject?>(
          'notification'.toJS,
        );

        if (notification == null) {
          return;
        }

        final title = notification.getProperty<JSString?>('title'.toJS);

        if (title == null || title.toDart.isEmpty) {
          return;
        }

        final body = notification.getProperty<JSString?>('body'.toJS);

        final image = notification.getProperty<JSString?>('image'.toJS);

        final icon = image?.toDart.isNotEmpty == true
            ? image!
            : '/icons/Icon-192.png'.toJS

        final notificationOptions =
            <String, JSAny?>{'body': body, 'icon': icon}.jsify() as JSObject;

        self.registration.showNotification(title, notificationOptions);
      }).toJS,
    );
  });
}
