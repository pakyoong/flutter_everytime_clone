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
    apiKey: 'AIzaSyA3yUJ4mHLAY7vl3QrVex7JGPdU4nKQk2M',
    appId: '1:358879497597:web:c285a5c9b09c897240d014',
    messagingSenderId: '358879497597',
    projectId: 'everytime-9930d',
    authDomain: 'everytime-9930d.firebaseapp.com',
    storageBucket: 'everytime-9930d.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAjJTQ-tjhqGW0_d4DIR6p_HaE-cyNPzXk',
    appId: '1:358879497597:android:375613dc7706a39f40d014',
    messagingSenderId: '358879497597',
    projectId: 'everytime-9930d',
    storageBucket: 'everytime-9930d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB254Eedwa69l-w53DnD4BOAXxf4mmQ7bY',
    appId: '1:358879497597:ios:aac443cf94cd777840d014',
    messagingSenderId: '358879497597',
    projectId: 'everytime-9930d',
    storageBucket: 'everytime-9930d.appspot.com',
    iosBundleId: 'com.example.everytime',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB254Eedwa69l-w53DnD4BOAXxf4mmQ7bY',
    appId: '1:358879497597:ios:7194011f20cc835140d014',
    messagingSenderId: '358879497597',
    projectId: 'everytime-9930d',
    storageBucket: 'everytime-9930d.appspot.com',
    iosBundleId: 'com.example.everytime.RunnerTests',
  );
}