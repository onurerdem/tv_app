// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

  static FirebaseOptions web = FirebaseOptions(
    apiKey: dotenv.env['FIREBASE_WEB_WINDOWS_API_KEY']!,
    appId: '1:95103168259:web:493d0a37e58e65a4d44336',
    messagingSenderId: '95103168259',
    projectId: 'tvapp-1caf5',
    authDomain: 'tvapp-1caf5.firebaseapp.com',
    storageBucket: 'tvapp-1caf5.firebasestorage.app',
    measurementId: 'G-L9M455S78D',
  );

  static FirebaseOptions android = FirebaseOptions(
    apiKey: dotenv.env['FIREBASE_ANDROID_API_KEY']!,
    appId: '1:95103168259:android:db96b00233de7bf6d44336',
    messagingSenderId: '95103168259',
    projectId: 'tvapp-1caf5',
    storageBucket: 'tvapp-1caf5.firebasestorage.app',
  );

  static FirebaseOptions ios = FirebaseOptions(
    apiKey: dotenv.env['FIREBASE_IOS_MACOS_API_KEY']!,
    appId: '1:95103168259:ios:3afedbffc7be9b33d44336',
    messagingSenderId: '95103168259',
    projectId: 'tvapp-1caf5',
    storageBucket: 'tvapp-1caf5.firebasestorage.app',
    iosBundleId: 'com.onurerdem.tvApp',
  );

  static FirebaseOptions macos = FirebaseOptions(
    apiKey: dotenv.env['FIREBASE_IOS_MACOS_API_KEY']!,
    appId: '1:95103168259:ios:3afedbffc7be9b33d44336',
    messagingSenderId: '95103168259',
    projectId: 'tvapp-1caf5',
    storageBucket: 'tvapp-1caf5.firebasestorage.app',
    iosBundleId: 'com.onurerdem.tvApp',
  );

  static FirebaseOptions windows = FirebaseOptions(
    apiKey: dotenv.env['FIREBASE_WEB_WINDOWS_API_KEY']!,
    appId: '1:95103168259:web:ee84d961a3cdd0a7d44336',
    messagingSenderId: '95103168259',
    projectId: 'tvapp-1caf5',
    authDomain: 'tvapp-1caf5.firebaseapp.com',
    storageBucket: 'tvapp-1caf5.firebasestorage.app',
    measurementId: 'G-FL7RRXDQQS',
  );
}
