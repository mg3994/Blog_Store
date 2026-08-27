///Try replacing your firebase_options code with this
///
// static const FirebaseOptions web = FirebaseOptions(
//   apiKey: FirebaseWebConfig.apiKey,
//   appId: FirebaseWebConfig.appId,
//   messagingSenderId: FirebaseWebConfig.messagingSenderId,
//   projectId: FirebaseWebConfig.projectId,
//   authDomain: FirebaseWebConfig.authDomain,
//   storageBucket: FirebaseWebConfig.storageBucket,
//   measurementId: FirebaseWebConfig.measurementId,
// );

// lib/firebase_web_config.dart
// put all those firebase config web stuff one by one here
abstract final class FirebaseWebConfig {
  static const String apiKey = 'AIzaSyBIXxQgUPYDU2srK_UpgjiTATON5rrdMd0';
  static const String appId = '1:132381301913:web:f0d0a643bc90bed91eec08';
  static const String messagingSenderId = '132381301913';
  static const String projectId = 'flutterfire-samples';
  static const String authDomain = 'flutterfire-samples.firebaseapp.com';
  static const String storageBucket = 'flutterfire-samples.appspot.com';
  static const String measurementId = 'G-ZK5194H8VH';
}
