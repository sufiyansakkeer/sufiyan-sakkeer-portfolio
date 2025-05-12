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
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        return linux;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDpZwHG4wVOUyfHXWiojDOeT6KSKMH_pbo',
    appId: '1:804519308110:web:705691bcac451c7d088c1f',
    messagingSenderId: '804519308110',
    projectId: 'sufiyan-sakkeer',
    authDomain: 'sufiyan-sakkeer.firebaseapp.com',
    storageBucket: 'sufiyan-sakkeer.firebasestorage.app',
    measurementId: 'G-5MDGCEN4TZ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAzB7W-Cn_MTTX-go56VUWtqTJ73Di6T8s',
    appId: '1:804519308110:android:e28948629e39d309088c1f',
    messagingSenderId: '804519308110',
    projectId: 'sufiyan-sakkeer',
    storageBucket: 'sufiyan-sakkeer.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC0dOL5nhMifAbMNOc8-wAnpc4QShN09WI',
    appId: '1:804519308110:ios:71f55760adcc9259088c1f',
    messagingSenderId: '804519308110',
    projectId: 'sufiyan-sakkeer',
    storageBucket: 'sufiyan-sakkeer.firebasestorage.app',
    iosBundleId: 'com.example.portfolio',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC0dOL5nhMifAbMNOc8-wAnpc4QShN09WI',
    appId: '1:804519308110:ios:71f55760adcc9259088c1f',
    messagingSenderId: '804519308110',
    projectId: 'sufiyan-sakkeer',
    storageBucket: 'sufiyan-sakkeer.firebasestorage.app',
    iosBundleId: 'com.example.portfolio',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDpZwHG4wVOUyfHXWiojDOeT6KSKMH_pbo',
    appId: '1:804519308110:web:68918ef188b522a0088c1f',
    messagingSenderId: '804519308110',
    projectId: 'sufiyan-sakkeer',
    authDomain: 'sufiyan-sakkeer.firebaseapp.com',
    storageBucket: 'sufiyan-sakkeer.firebasestorage.app',
    measurementId: 'G-3SR3QVJQ5Y',
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'YOUR_API_KEY',
    appId: 'YOUR_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_STORAGE_BUCKET',
  );
}