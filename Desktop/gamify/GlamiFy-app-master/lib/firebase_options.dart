// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCzgO6dwYykFBrtK6tv1uK-gSI_SU2I6u8',
    appId: '1:222835318245:web:7825b7b911120cb8f9e30c',
    messagingSenderId: '222835318245',
    projectId: 'glamify-a14d5',
    authDomain: 'glamify-a14d5.firebaseapp.com',
    databaseURL: 'https://glamify-a14d5-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'glamify-a14d5.appspot.com',
    measurementId: 'G-P7S6DGR1B0',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAEEPmID3AGwQVi_6rTaywEWECqC3G0XEs',
    appId: '1:222835318245:android:dfb58b731cc5dc24f9e30c',
    messagingSenderId: '222835318245',
    projectId: 'glamify-a14d5',
    databaseURL: 'https://glamify-a14d5-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'glamify-a14d5.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB7StKjohScuYuc_PllVELyerQlja8HZog',
    appId: '1:222835318245:ios:edd01cabd1e20d3bf9e30c',
    messagingSenderId: '222835318245',
    projectId: 'glamify-a14d5',
    databaseURL: 'https://glamify-a14d5-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'glamify-a14d5.appspot.com',
    androidClientId: '222835318245-g6349naktu1tdcf6f3e2q3i35qr6ud1a.apps.googleusercontent.com',
    iosClientId: '222835318245-tdm3t90f0a7j4caqpa2anp7ctsvqm0d5.apps.googleusercontent.com',
    iosBundleId: 'com.example.glamifyApp',
  );

}