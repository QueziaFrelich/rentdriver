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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyDXQI-Yqr84qgT11Xs8JwVlvGjuYO48VFM',
    appId: '1:390558124989:web:1b58073a09f15d8554e0d4',
    messagingSenderId: '390558124989',
    projectId: 'rentdrive',
    authDomain: 'rentdrive.firebaseapp.com',
    storageBucket: 'rentdrive.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCGnyV7KuI8eKQelWwXM5drUNeJ7iWb07k',
    appId: '1:390558124989:android:3e84694ee6a6aa7054e0d4',
    messagingSenderId: '390558124989',
    projectId: 'rentdrive',
    storageBucket: 'rentdrive.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDyOjhm9vGpV8423ZsYENCd3dv-hQ6psnU',
    appId: '1:390558124989:ios:2f6182acfeaad16854e0d4',
    messagingSenderId: '390558124989',
    projectId: 'rentdrive',
    storageBucket: 'rentdrive.appspot.com',
    iosBundleId: 'com.example.rentdriver',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDyOjhm9vGpV8423ZsYENCd3dv-hQ6psnU',
    appId: '1:390558124989:ios:2f6182acfeaad16854e0d4',
    messagingSenderId: '390558124989',
    projectId: 'rentdrive',
    storageBucket: 'rentdrive.appspot.com',
    iosBundleId: 'com.example.rentdriver',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDXQI-Yqr84qgT11Xs8JwVlvGjuYO48VFM',
    appId: '1:390558124989:web:5a1b99c573d8012a54e0d4',
    messagingSenderId: '390558124989',
    projectId: 'rentdrive',
    authDomain: 'rentdrive.firebaseapp.com',
    storageBucket: 'rentdrive.appspot.com',
  );
}
