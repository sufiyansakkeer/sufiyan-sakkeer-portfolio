import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:js' as js;
import 'app.dart';
import 'firebase_options.dart';
import 'package:portfolio/utils/performance_optimizer.dart';

// Global variable to track Firebase initialization status
bool isFirebaseInitialized = false;

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with proper error handling
  await initializeFirebase();

  // Optimize performance
  PerformanceOptimizer().optimizeFrameRate();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  // Run the app
  runApp(const PortfolioApp());
}

/// Initialize Firebase with proper error handling for all platforms
Future<void> initializeFirebase() async {
  try {
    // For web platform, check if Firebase was already initialized by the web script
    if (kIsWeb) {
      try {
        // Check if Firebase is already initialized in JavaScript
        if (js.context.hasProperty('firebaseInitialized') &&
            js.context['firebaseInitialized'] == true) {
          debugPrint('Firebase already initialized by web script');
          isFirebaseInitialized = true;
          return;
        } else {
          debugPrint(
            'Firebase not initialized by web script, initializing from Dart',
          );
        }
      } catch (e) {
        debugPrint('Error checking web Firebase initialization: $e');
        // Continue with normal initialization
      }
    }

    // Initialize Firebase with platform-specific options
    final FirebaseApp app = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    debugPrint('Firebase initialized successfully: ${app.name}');

    // Set global flag to indicate Firebase is initialized
    isFirebaseInitialized = true;

    // For web platform, perform additional checks
    if (kIsWeb) {
      // Verify that Firebase is properly initialized for web
      try {
        // This is a simple check to see if Firebase is properly initialized
        // Just accessing the instance is enough to verify initialization
        FirebaseFirestore.instance;
        debugPrint('Firestore instance created successfully');
      } catch (e) {
        debugPrint('Error creating Firestore instance: $e');
        // Re-throw to be caught by the outer try-catch
        rethrow;
      }
    }
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
    // Set flag to indicate Firebase failed to initialize
    isFirebaseInitialized = false;

    // For debugging purposes, print more detailed error information
    if (kIsWeb) {
      debugPrint(
        'Firebase web initialization failed. Check your Firebase configuration and web setup.',
      );
    } else {
      debugPrint(
        'Firebase initialization failed on ${defaultTargetPlatform.toString()}',
      );
    }
  }
}
