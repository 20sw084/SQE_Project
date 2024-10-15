import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
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
    apiKey: 'AIzaSyAHQ94lXdVa9VDU59ueYFGqrB0zaCJZap4',
    appId: '1:504805874781:web:dbcde6386f0f4f88bbc1b4',
    messagingSenderId: '504805874781',
    projectId: 'medwell-6dfcf',
    authDomain: 'medwell-6dfcf.firebaseapp.com',
    storageBucket: 'medwell-6dfcf.appspot.com',
    measurementId: 'G-VF56P6VYSY',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAELXbG83O6fZyvbVk__sW8LhjGzQXVUWU',
    appId: '1:504805874781:android:55c9d3e844559e8fbbc1b4',
    messagingSenderId: '504805874781',
    projectId: 'medwell-6dfcf',
    storageBucket: 'medwell-6dfcf.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAZaHpMSJawolpC0UlqjhXLdU2slEDwYu8',
    appId: '1:504805874781:ios:bdc7a787548eac4dbbc1b4',
    messagingSenderId: '504805874781',
    projectId: 'medwell-6dfcf',
    storageBucket: 'medwell-6dfcf.appspot.com',
    iosClientId: '504805874781-65229c0qcb87fa1sflq6bk08vp2336kt.apps.googleusercontent.com',
    iosBundleId: 'com.example.medwell',
  );
}
