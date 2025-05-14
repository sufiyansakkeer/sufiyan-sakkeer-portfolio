// ignore: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:js_util' as js_util;
import 'package:flutter/foundation.dart';

/// Utility class for handling web platform specific issues
class WebPlatformUtils {
  /// Initialize platform-specific error handling and web setup
  static void initializeErrorHandling() {
    if (_isWeb) {
      _setupErrorListeners();
      _setupWebInitialization();
    }
  }

  /// Check if running on web platform
  static bool get _isWeb => kIsWeb;

  /// Set up error listeners for web platform
  static void _setupErrorListeners() {
    try {
      // Handle ad blocker detection events from JavaScript
      js_util.callMethod(js_util.globalThis, 'addEventListener', [
        'adBlockerDetected',
        js_util.allowInterop((dynamic _) {
          debugPrint('Ad blocker detected in Dart code');
          // You can update your app state here
        }),
      ]);

      // Create safe wrapper for JS interop calls
      js_util.setProperty(
        js_util.globalThis,
        'dartCallback',
        js_util.allowInterop((dynamic args) {
          try {
            // Process args from JavaScript
            debugPrint('Received callback from JavaScript: $args');
            return true;
          } catch (e) {
            debugPrint('Error in dartCallback: $e');
            return false;
          }
        }),
      );

      debugPrint('Set up error listeners for web platform');
    } catch (e) {
      debugPrint('Error setting up error listeners: $e');
    }
  }

  /// Setup web initialization with proper configuration
  static void _setupWebInitialization() {
    try {
      // Ensure _flutter object exists
      _ensureFlutterObject();

      // Set up the build configuration
      _setupBuildConfig();

      // Register a callback to hide the loading screen when the app is ready
      _registerHideLoadingScreenCallback();

      debugPrint('Web initialization setup completed successfully');
    } catch (e) {
      debugPrint('Error setting up web initialization: $e');
    }
  }

  /// Ensure the _flutter object exists in the JavaScript context
  static void _ensureFlutterObject() {
    try {
      final jsWindow = js_util.globalThis;

      // Check if _flutter exists
      if (!js_util.hasProperty(jsWindow, '_flutter')) {
        // Create _flutter object
        js_util.setProperty(jsWindow, '_flutter', js_util.newObject());
        debugPrint('Created _flutter object in global context');
      }

      // Get the _flutter object
      final flutterObj = js_util.getProperty(jsWindow, '_flutter');

      // Ensure loader object exists
      if (!js_util.hasProperty(flutterObj, 'loader')) {
        js_util.setProperty(flutterObj, 'loader', js_util.newObject());
        debugPrint('Created _flutter.loader object');
      }
    } catch (e) {
      debugPrint('Error ensuring Flutter object: $e');
    }
  }

  /// Set up the build configuration required by FlutterLoader.load
  static void _setupBuildConfig() {
    try {
      final jsWindow = js_util.globalThis;
      final flutterObj = js_util.getProperty(jsWindow, '_flutter');

      // Create buildConfig if it doesn't exist
      if (!js_util.hasProperty(flutterObj, 'buildConfig')) {
        // Create a configuration object with CanvasKit renderer for better animation performance
        final config = js_util.newObject();

        // Set canvasKit renderer
        js_util.setProperty(config, 'renderer', 'canvaskit');

        // Add service worker configuration if available
        if (js_util.hasProperty(jsWindow, 'serviceWorkerVersion')) {
          final serviceWorkerConfig = js_util.newObject();
          js_util.setProperty(
            serviceWorkerConfig,
            'serviceWorkerVersion',
            js_util.getProperty(jsWindow, 'serviceWorkerVersion'),
          );
          js_util.setProperty(config, 'serviceWorker', serviceWorkerConfig);
        }

        // Set the build configuration
        js_util.setProperty(flutterObj, 'buildConfig', config);
        debugPrint('Set _flutter.buildConfig with CanvasKit renderer');
      }
    } catch (e) {
      debugPrint('Error setting up build configuration: $e');
    }
  }

  /// Register a callback to hide the loading screen when the app is ready
  static void _registerHideLoadingScreenCallback() {
    try {
      final jsWindow = js_util.globalThis;

      // Create a function to hide the loading screen from Dart
      js_util.setProperty(
        jsWindow,
        'dartHideLoadingScreen',
        js_util.allowInterop(() {
          try {
            // Call the JavaScript hideLoadingScreen function if it exists
            if (js_util.hasProperty(jsWindow, 'hideLoadingScreen')) {
              final hideLoadingScreen = js_util.getProperty(
                jsWindow,
                'hideLoadingScreen',
              );
              if (hideLoadingScreen is Function) {
                js_util.callMethod(jsWindow, 'hideLoadingScreen', []);
                debugPrint('Called hideLoadingScreen from Dart');
              }
            } else {
              debugPrint('hideLoadingScreen function not found in JavaScript');
              // Fallback to manually hiding the loading element
              final document = js_util.getProperty(jsWindow, 'document');
              final loadingElement = js_util.callMethod(
                document,
                'getElementById',
                ['loading'],
              );

              if (loadingElement != null) {
                final style = js_util.getProperty(loadingElement, 'style');
                js_util.setProperty(style, 'opacity', '0');

                // Use setTimeout to remove the element after the fade out
                js_util.callMethod(jsWindow, 'setTimeout', [
                  js_util.allowInterop(() {
                    js_util.setProperty(style, 'display', 'none');
                  }),
                  300,
                ]);
                debugPrint('Manually hid loading element');
              }
            }
            return true;
          } catch (e) {
            debugPrint('Error hiding loading screen: $e');
            return false;
          }
        }),
      );

      debugPrint('Registered dartHideLoadingScreen callback');
    } catch (e) {
      debugPrint('Error registering hide loading screen callback: $e');
    }
  }

  /// Hide the loading screen from Dart code
  static void hideLoadingScreen() {
    if (!_isWeb) return;

    try {
      final jsWindow = js_util.globalThis;
      if (js_util.hasProperty(jsWindow, 'dartHideLoadingScreen')) {
        js_util.callMethod(jsWindow, 'dartHideLoadingScreen', []);
      }
    } catch (e) {
      debugPrint('Error calling dartHideLoadingScreen: $e');
    }
  }

  /// Checks if Firebase has already been initialized in JavaScript
  /// Returns true if Firebase is already initialized, false otherwise
  static bool isFirebaseInitializedInJS() {
    if (!_isWeb) return false;

    try {
      final jsWindow = js_util.globalThis;

      // Check if the Firebase app object exists in the JS context
      if (!js_util.hasProperty(jsWindow, 'firebase')) {
        return false;
      }

      // Access the 'apps' property (it's an array, not a method)
      final firebaseObj = js_util.getProperty(jsWindow, 'firebase');
      if (!js_util.hasProperty(firebaseObj, 'apps')) {
        return false;
      }

      // Get the apps array
      final apps = js_util.getProperty(firebaseObj, 'apps');
      if (apps == null) {
        return false;
      }

      // Check if the apps array has any elements using the 'length' property
      if (!js_util.hasProperty(apps, 'length')) {
        return false;
      }

      final length = js_util.getProperty(apps, 'length');
      // Convert to int
      final lengthInt = length as int;

      return lengthInt > 0;
    } catch (e) {
      debugPrint('Error checking Firebase initialization in JS: $e');
      return false;
    }
  }
}
