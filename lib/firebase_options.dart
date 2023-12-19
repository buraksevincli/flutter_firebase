// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC9SlKzpCcCiXPOivCOCYXMn9aR8Z4K5to',
    appId: '1:180101403471:web:91e7c9145c6fab74a3ab3a',
    messagingSenderId: '180101403471',
    projectId: 'flutter-firebase-28c84',
    authDomain: 'flutter-firebase-28c84.firebaseapp.com',
    storageBucket: 'flutter-firebase-28c84.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB4lZvBNLu3GET9JiwKqoEF-VY6L0rMYKg',
    appId: '1:180101403471:android:a70ae885c25b3969a3ab3a',
    messagingSenderId: '180101403471',
    projectId: 'flutter-firebase-28c84',
    storageBucket: 'flutter-firebase-28c84.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAYYX5vk6qeBEGrgUq7CJK658G6wRtPIxE',
    appId: '1:180101403471:ios:fea3d53a273c18c5a3ab3a',
    messagingSenderId: '180101403471',
    projectId: 'flutter-firebase-28c84',
    storageBucket: 'flutter-firebase-28c84.appspot.com',
    iosBundleId: 'com.buraksevincli.flutterFirebase',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAYYX5vk6qeBEGrgUq7CJK658G6wRtPIxE',
    appId: '1:180101403471:ios:2672ba8080e2fe00a3ab3a',
    messagingSenderId: '180101403471',
    projectId: 'flutter-firebase-28c84',
    storageBucket: 'flutter-firebase-28c84.appspot.com',
    iosBundleId: 'com.buraksevincli.flutterFirebase.RunnerTests',
  );
}
