import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform, kDebugMode;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Secure Firebase configuration class that loads API keys from environment variables
///
/// This class replaces the hardcoded API keys in firebase_options.dart with
/// environment-based configuration for better security.
///
/// Usage:
/// 1. Set environment variables for your Firebase configuration
/// 2. Use SecureFirebaseConfig.currentPlatform instead of DefaultFirebaseOptions.currentPlatform
class SecureFirebaseConfig {
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
          'SecureFirebaseConfig is not supported for this platform.',
        );
    }
  }

  /// Web Firebase configuration
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

  /// Android Firebase configuration
  static FirebaseOptions get android => FirebaseOptions(
    apiKey: _getEnvVar('FIREBASE_ANDROID_API_KEY', 'YOUR_ANDROID_API_KEY_HERE'),
    appId: _getEnvVar(
      'FIREBASE_ANDROID_APP_ID',
      '1:804519308110:android:e28948629e39d309088c1f',
    ),
    messagingSenderId: _getEnvVar(
      'FIREBASE_MESSAGING_SENDER_ID',
      '804519308110',
    ),
    projectId: _getEnvVar('FIREBASE_PROJECT_ID', 'sufiyan-sakkeer'),
    storageBucket: _getEnvVar(
      'FIREBASE_STORAGE_BUCKET',
      'sufiyan-sakkeer.firebasestorage.app',
    ),
  );

  /// iOS Firebase configuration
  static FirebaseOptions get ios => FirebaseOptions(
    apiKey: _getEnvVar('FIREBASE_IOS_API_KEY', 'YOUR_IOS_API_KEY_HERE'),
    appId: _getEnvVar(
      'FIREBASE_IOS_APP_ID',
      '1:804519308110:ios:71f55760adcc9259088c1f',
    ),
    messagingSenderId: _getEnvVar(
      'FIREBASE_MESSAGING_SENDER_ID',
      '804519308110',
    ),
    projectId: _getEnvVar('FIREBASE_PROJECT_ID', 'sufiyan-sakkeer'),
    storageBucket: _getEnvVar(
      'FIREBASE_STORAGE_BUCKET',
      'sufiyan-sakkeer.firebasestorage.app',
    ),
    iosBundleId: _getEnvVar('FIREBASE_IOS_BUNDLE_ID', 'com.example.portfolio'),
  );

  /// macOS Firebase configuration
  static FirebaseOptions get macos => FirebaseOptions(
    apiKey: _getEnvVar('FIREBASE_IOS_API_KEY', 'YOUR_IOS_API_KEY_HERE'),
    appId: _getEnvVar(
      'FIREBASE_IOS_APP_ID',
      '1:804519308110:ios:71f55760adcc9259088c1f',
    ),
    messagingSenderId: _getEnvVar(
      'FIREBASE_MESSAGING_SENDER_ID',
      '804519308110',
    ),
    projectId: _getEnvVar('FIREBASE_PROJECT_ID', 'sufiyan-sakkeer'),
    storageBucket: _getEnvVar(
      'FIREBASE_STORAGE_BUCKET',
      'sufiyan-sakkeer.firebasestorage.app',
    ),
    iosBundleId: _getEnvVar('FIREBASE_IOS_BUNDLE_ID', 'com.example.portfolio'),
  );

  /// Windows Firebase configuration
  static FirebaseOptions get windows => FirebaseOptions(
    apiKey: _getEnvVar('FIREBASE_WEB_API_KEY', 'YOUR_WEB_API_KEY_HERE'),
    appId: _getEnvVar(
      'FIREBASE_WINDOWS_APP_ID',
      '1:804519308110:web:68918ef188b522a0088c1f',
    ),
    messagingSenderId: _getEnvVar(
      'FIREBASE_MESSAGING_SENDER_ID',
      '804519308110',
    ),
    projectId: _getEnvVar('FIREBASE_PROJECT_ID', 'sufiyan-sakkeer'),
    authDomain: _getEnvVar(
      'FIREBASE_AUTH_DOMAIN',
      'sufiyan-sakkeer.firebaseapp.com',
    ),
    storageBucket: _getEnvVar(
      'FIREBASE_STORAGE_BUCKET',
      'sufiyan-sakkeer.firebasestorage.app',
    ),
    measurementId: _getEnvVar(
      'FIREBASE_WINDOWS_MEASUREMENT_ID',
      'G-3SR3QVJQ5Y',
    ),
  );

  /// Linux Firebase configuration (placeholder)
  static FirebaseOptions get linux => const FirebaseOptions(
    apiKey: 'YOUR_API_KEY',
    appId: 'YOUR_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_STORAGE_BUCKET',
  );

  /// Helper method to get environment variables with fallback values
  ///
  /// This method loads environment variables from the .env file using flutter_dotenv.
  /// In production, consider removing fallback values and throwing an error if
  /// environment variables are not set for better security.
  static String _getEnvVar(String key, String fallback) {
    try {
      // First try to get from compile-time environment (for --dart-define)
      final compileTimeValue = String.fromEnvironment(key, defaultValue: '');
      if (compileTimeValue.isNotEmpty) {
        return compileTimeValue;
      }

      // Then try to get from .env file using flutter_dotenv
      final envValue = dotenv.env[key];
      if (envValue != null && envValue.isNotEmpty) {
        return envValue;
      }

      // If neither is available, use fallback for development
      // In production, you might want to throw an error instead:
      // throw Exception('Environment variable $key is not set');

      return fallback;
    } catch (e) {
      // If there's any error loading environment variables, use fallback
      // This ensures the app doesn't crash during development
      if (kDebugMode) {
        print('Warning: Failed to load environment variable $key: $e');
      }
      return fallback;
    }
  }

  /// Initialize environment variables
  ///
  /// This method should be called before using any Firebase configuration.
  /// It loads the .env file using flutter_dotenv.
  static Future<void> initialize() async {
    try {
      await dotenv.load(fileName: '.env');
      if (kDebugMode) {
        print('Environment variables loaded successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Warning: Failed to load .env file: $e');
        print('Using fallback values for Firebase configuration');
      }
      // Don't throw error - allow app to continue with fallback values
    }
  }
}
