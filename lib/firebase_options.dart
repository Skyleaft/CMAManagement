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
    apiKey: 'AIzaSyAxOquy-jDHO5EdpKjpBwNdNMokT5LYm9c',
    appId: '1:763625489768:web:d8f77a0558b684f0b182dd',
    messagingSenderId: '763625489768',
    projectId: 'cma-api-58c1f',
    authDomain: 'cma-api-58c1f.firebaseapp.com',
    storageBucket: 'cma-api-58c1f.appspot.com',
    measurementId: 'G-W630QPYYS6',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAurroH2iqPhKX5-8S_EFoZcfKbAOjDS-0',
    appId: '1:763625489768:android:01b518df2a4ab00ab182dd',
    messagingSenderId: '763625489768',
    projectId: 'cma-api-58c1f',
    storageBucket: 'cma-api-58c1f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBCwMG06K5z25Ivv_uxu20aBW1j9VDEGb0',
    appId: '1:763625489768:ios:afa619ad9c667d94b182dd',
    messagingSenderId: '763625489768',
    projectId: 'cma-api-58c1f',
    storageBucket: 'cma-api-58c1f.appspot.com',
    iosClientId: '763625489768-1pmrpo32mgvic9sts7ti805eh7pqdti3.apps.googleusercontent.com',
    iosBundleId: 'com.example.cmaManagement',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBCwMG06K5z25Ivv_uxu20aBW1j9VDEGb0',
    appId: '1:763625489768:ios:afa619ad9c667d94b182dd',
    messagingSenderId: '763625489768',
    projectId: 'cma-api-58c1f',
    storageBucket: 'cma-api-58c1f.appspot.com',
    iosClientId: '763625489768-1pmrpo32mgvic9sts7ti805eh7pqdti3.apps.googleusercontent.com',
    iosBundleId: 'com.example.cmaManagement',
  );
}