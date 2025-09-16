import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform, kDebugMode;

/// Firebase configuration template for public repositories
///
/// IMPORTANT: This file contains template placeholders for Firebase configuration.
/// Before using this project:
/// 1. Copy .env.example to .env
/// 2. Replace placeholder values in .env with your actual Firebase configuration
/// 3. The app will automatically load your configuration from environment variables
///
/// This approach keeps sensitive API keys out of your source code while maintaining
/// a functional template that others can use.
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

  /// Helper method to get environment variables with secure fallbacks
  static String _getEnvVar(String key, String placeholder) {
    // Try to get the specific environment variable
    final envValue = _getSpecificEnvVar(key);
    if (envValue.isNotEmpty) {
      return envValue;
    }

    // In development, show helpful message
    if (kDebugMode) {
      // ignore: avoid_print
      print('⚠️  Environment variable $key not set, using placeholder');
      // ignore: avoid_print
      print('   Please configure your Firebase settings in .env file');
    }
    return placeholder;
  }

  /// Get specific environment variable by key
  static String _getSpecificEnvVar(String key) {
    switch (key) {
      case 'FIREBASE_WEB_API_KEY':
        return const String.fromEnvironment(
          'FIREBASE_WEB_API_KEY',
          defaultValue: '',
        );
      case 'FIREBASE_WEB_APP_ID':
        return const String.fromEnvironment(
          'FIREBASE_WEB_APP_ID',
          defaultValue: '',
        );
      case 'FIREBASE_ANDROID_API_KEY':
        return const String.fromEnvironment(
          'FIREBASE_ANDROID_API_KEY',
          defaultValue: '',
        );
      case 'FIREBASE_ANDROID_APP_ID':
        return const String.fromEnvironment(
          'FIREBASE_ANDROID_APP_ID',
          defaultValue: '',
        );
      case 'FIREBASE_IOS_API_KEY':
        return const String.fromEnvironment(
          'FIREBASE_IOS_API_KEY',
          defaultValue: '',
        );
      case 'FIREBASE_IOS_APP_ID':
        return const String.fromEnvironment(
          'FIREBASE_IOS_APP_ID',
          defaultValue: '',
        );
      case 'FIREBASE_PROJECT_ID':
        return const String.fromEnvironment(
          'FIREBASE_PROJECT_ID',
          defaultValue: '',
        );
      case 'FIREBASE_MESSAGING_SENDER_ID':
        return const String.fromEnvironment(
          'FIREBASE_MESSAGING_SENDER_ID',
          defaultValue: '',
        );
      case 'FIREBASE_AUTH_DOMAIN':
        return const String.fromEnvironment(
          'FIREBASE_AUTH_DOMAIN',
          defaultValue: '',
        );
      case 'FIREBASE_STORAGE_BUCKET':
        return const String.fromEnvironment(
          'FIREBASE_STORAGE_BUCKET',
          defaultValue: '',
        );
      case 'FIREBASE_WEB_MEASUREMENT_ID':
        return const String.fromEnvironment(
          'FIREBASE_WEB_MEASUREMENT_ID',
          defaultValue: '',
        );
      case 'FIREBASE_WINDOWS_APP_ID':
        return const String.fromEnvironment(
          'FIREBASE_WINDOWS_APP_ID',
          defaultValue: '',
        );
      case 'FIREBASE_WINDOWS_MEASUREMENT_ID':
        return const String.fromEnvironment(
          'FIREBASE_WINDOWS_MEASUREMENT_ID',
          defaultValue: '',
        );
      case 'FIREBASE_IOS_BUNDLE_ID':
        return const String.fromEnvironment(
          'FIREBASE_IOS_BUNDLE_ID',
          defaultValue: '',
        );
      default:
        return '';
    }
  }

  static FirebaseOptions get web => FirebaseOptions(
    apiKey: _getEnvVar('FIREBASE_WEB_API_KEY', 'YOUR_WEB_API_KEY_HERE'),
    appId: _getEnvVar('FIREBASE_WEB_APP_ID', 'YOUR_WEB_APP_ID_HERE'),
    messagingSenderId: _getEnvVar(
      'FIREBASE_MESSAGING_SENDER_ID',
      'YOUR_MESSAGING_SENDER_ID_HERE',
    ),
    projectId: _getEnvVar('FIREBASE_PROJECT_ID', 'your-project-id'),
    authDomain: _getEnvVar(
      'FIREBASE_AUTH_DOMAIN',
      'your-project.firebaseapp.com',
    ),
    storageBucket: _getEnvVar(
      'FIREBASE_STORAGE_BUCKET',
      'your-project.firebasestorage.app',
    ),
    measurementId: _getEnvVar(
      'FIREBASE_WEB_MEASUREMENT_ID',
      'YOUR_WEB_MEASUREMENT_ID_HERE',
    ),
  );

  static FirebaseOptions get android => FirebaseOptions(
    apiKey: _getEnvVar('FIREBASE_ANDROID_API_KEY', 'YOUR_ANDROID_API_KEY_HERE'),
    appId: _getEnvVar('FIREBASE_ANDROID_APP_ID', 'YOUR_ANDROID_APP_ID_HERE'),
    messagingSenderId: _getEnvVar(
      'FIREBASE_MESSAGING_SENDER_ID',
      'YOUR_MESSAGING_SENDER_ID_HERE',
    ),
    projectId: _getEnvVar('FIREBASE_PROJECT_ID', 'your-project-id'),
    storageBucket: _getEnvVar(
      'FIREBASE_STORAGE_BUCKET',
      'your-project.firebasestorage.app',
    ),
  );

  static FirebaseOptions get ios => FirebaseOptions(
    apiKey: _getEnvVar('FIREBASE_IOS_API_KEY', 'YOUR_IOS_API_KEY_HERE'),
    appId: _getEnvVar('FIREBASE_IOS_APP_ID', 'YOUR_IOS_APP_ID_HERE'),
    messagingSenderId: _getEnvVar(
      'FIREBASE_MESSAGING_SENDER_ID',
      'YOUR_MESSAGING_SENDER_ID_HERE',
    ),
    projectId: _getEnvVar('FIREBASE_PROJECT_ID', 'your-project-id'),
    storageBucket: _getEnvVar(
      'FIREBASE_STORAGE_BUCKET',
      'your-project.firebasestorage.app',
    ),
    iosBundleId: _getEnvVar('FIREBASE_IOS_BUNDLE_ID', 'com.example.your-app'),
  );

  static FirebaseOptions get macos => FirebaseOptions(
    apiKey: _getEnvVar('FIREBASE_IOS_API_KEY', 'YOUR_IOS_API_KEY_HERE'),
    appId: _getEnvVar('FIREBASE_IOS_APP_ID', 'YOUR_IOS_APP_ID_HERE'),
    messagingSenderId: _getEnvVar(
      'FIREBASE_MESSAGING_SENDER_ID',
      'YOUR_MESSAGING_SENDER_ID_HERE',
    ),
    projectId: _getEnvVar('FIREBASE_PROJECT_ID', 'your-project-id'),
    storageBucket: _getEnvVar(
      'FIREBASE_STORAGE_BUCKET',
      'your-project.firebasestorage.app',
    ),
    iosBundleId: _getEnvVar('FIREBASE_IOS_BUNDLE_ID', 'com.example.your-app'),
  );

  static FirebaseOptions get windows => FirebaseOptions(
    apiKey: _getEnvVar('FIREBASE_WEB_API_KEY', 'YOUR_WEB_API_KEY_HERE'),
    appId: _getEnvVar('FIREBASE_WINDOWS_APP_ID', 'YOUR_WINDOWS_APP_ID_HERE'),
    messagingSenderId: _getEnvVar(
      'FIREBASE_MESSAGING_SENDER_ID',
      'YOUR_MESSAGING_SENDER_ID_HERE',
    ),
    projectId: _getEnvVar('FIREBASE_PROJECT_ID', 'your-project-id'),
    authDomain: _getEnvVar(
      'FIREBASE_AUTH_DOMAIN',
      'your-project.firebaseapp.com',
    ),
    storageBucket: _getEnvVar(
      'FIREBASE_STORAGE_BUCKET',
      'your-project.firebasestorage.app',
    ),
    measurementId: _getEnvVar(
      'FIREBASE_WINDOWS_MEASUREMENT_ID',
      'YOUR_WINDOWS_MEASUREMENT_ID_HERE',
    ),
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'YOUR_LINUX_API_KEY_HERE',
    appId: 'YOUR_LINUX_APP_ID_HERE',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID_HERE',
    projectId: 'your-project-id',
    storageBucket: 'your-project.firebasestorage.app',
  );
}
