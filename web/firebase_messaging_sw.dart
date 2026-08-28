import 'dart:js_interop';

import 'package:blogstore/firebase_web_config.dart';

@JS('importScripts')
external void importScripts(JSString script1, JSString script2);

@JS('firebase.initializeApp')
external void initializeApp(JSObject options);

// @JS('firebase.messaging')
// external JSObject messaging();

@JS('firebase.messaging')
external FirebaseMessaging messaging();

@JS()
@staticInterop
class FirebaseMessaging {}

extension FirebaseMessagingExtension on FirebaseMessaging {
  external void onBackgroundMessage(JSFunction callback);
}

@JS('console.log')
external void consoleLog(JSAny? value);
void main() {
  importScripts(
    'https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js'.toJS,
    'https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js'
        .toJS,
  );

  final options =
      {
            'apiKey': FirebaseWebConfig.apiKey,
            'appId': FirebaseWebConfig.appId,
            'messagingSenderId': FirebaseWebConfig.messagingSenderId,
            'projectId': FirebaseWebConfig.projectId,
            'authDomain': FirebaseWebConfig.authDomain,
            'storageBucket': FirebaseWebConfig.storageBucket,
            'measurementId': FirebaseWebConfig.measurementId,
          }.jsify()
          as JSObject;

  initializeApp(options);
  final messagingInstance = messaging();

  messagingInstance.onBackgroundMessage(
    ((JSAny? message) {
      consoleLog(message);
    }).toJS,
  );
}
