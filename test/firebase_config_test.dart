import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/config/firebase_config.dart';

void main() {
  group('SecureFirebaseConfig Tests', () {
    setUpAll(() async {
      // Initialize environment variables for testing
      await SecureFirebaseConfig.initialize();
    });

    test('should initialize environment variables without throwing', () async {
      // This test verifies that the initialize method doesn't throw an error
      expect(
        () async => await SecureFirebaseConfig.initialize(),
        returnsNormally,
      );
    });

    test('should return valid Firebase options for all platforms', () {
      // Test web configuration
      final webOptions = SecureFirebaseConfig.web;
      expect(webOptions.apiKey, isNotEmpty);
      expect(webOptions.appId, isNotEmpty);
      expect(webOptions.projectId, isNotEmpty);
      expect(webOptions.messagingSenderId, isNotEmpty);

      // Test Android configuration
      final androidOptions = SecureFirebaseConfig.android;
      expect(androidOptions.apiKey, isNotEmpty);
      expect(androidOptions.appId, isNotEmpty);
      expect(androidOptions.projectId, isNotEmpty);
      expect(androidOptions.messagingSenderId, isNotEmpty);

      // Test iOS configuration
      final iosOptions = SecureFirebaseConfig.ios;
      expect(iosOptions.apiKey, isNotEmpty);
      expect(iosOptions.appId, isNotEmpty);
      expect(iosOptions.projectId, isNotEmpty);
      expect(iosOptions.messagingSenderId, isNotEmpty);
      expect(iosOptions.iosBundleId, isNotEmpty);

      // Test macOS configuration
      final macosOptions = SecureFirebaseConfig.macos;
      expect(macosOptions.apiKey, isNotEmpty);
      expect(macosOptions.appId, isNotEmpty);
      expect(macosOptions.projectId, isNotEmpty);
      expect(macosOptions.messagingSenderId, isNotEmpty);
      expect(macosOptions.iosBundleId, isNotEmpty);

      // Test Windows configuration
      final windowsOptions = SecureFirebaseConfig.windows;
      expect(windowsOptions.apiKey, isNotEmpty);
      expect(windowsOptions.appId, isNotEmpty);
      expect(windowsOptions.projectId, isNotEmpty);
      expect(windowsOptions.messagingSenderId, isNotEmpty);
      expect(windowsOptions.authDomain, isNotEmpty);
      expect(windowsOptions.storageBucket, isNotEmpty);

      // Test Linux configuration
      final linuxOptions = SecureFirebaseConfig.linux;
      expect(linuxOptions.apiKey, isNotEmpty);
      expect(linuxOptions.appId, isNotEmpty);
      expect(linuxOptions.projectId, isNotEmpty);
      expect(linuxOptions.messagingSenderId, isNotEmpty);
    });

    test('should return current platform configuration without throwing', () {
      expect(() => SecureFirebaseConfig.currentPlatform, returnsNormally);

      final currentPlatform = SecureFirebaseConfig.currentPlatform;
      expect(currentPlatform.apiKey, isNotEmpty);
      expect(currentPlatform.appId, isNotEmpty);
      expect(currentPlatform.projectId, isNotEmpty);
      expect(currentPlatform.messagingSenderId, isNotEmpty);
    });

    test('should handle missing environment variables gracefully', () {
      // This test verifies that the configuration works even when .env file is missing
      // The _getEnvVar method should return fallback values
      expect(() => SecureFirebaseConfig.currentPlatform, returnsNormally);
    });

    test('should load actual API keys from environment variables', () {
      // Test that actual API keys are loaded (not placeholder values)
      final webOptions = SecureFirebaseConfig.web;
      expect(webOptions.apiKey, startsWith('AIzaSy'));
      expect(webOptions.apiKey, isNot(equals('YOUR_WEB_API_KEY_HERE')));

      final androidOptions = SecureFirebaseConfig.android;
      expect(androidOptions.apiKey, startsWith('AIzaSy'));
      expect(androidOptions.apiKey, isNot(equals('YOUR_ANDROID_API_KEY_HERE')));

      final iosOptions = SecureFirebaseConfig.ios;
      expect(iosOptions.apiKey, startsWith('AIzaSy'));
      expect(iosOptions.apiKey, isNot(equals('YOUR_IOS_API_KEY_HERE')));
    });
  });
}
