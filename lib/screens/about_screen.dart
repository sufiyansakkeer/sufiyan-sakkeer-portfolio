import 'package:flutter/material.dart';
import 'package:portfolio/screens/about/about_screen.dart' as refactored;

/// Wrapper class that exports the refactored AboutScreen
/// This maintains backward compatibility with existing imports
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Simply delegate to the refactored AboutScreen
    return const refactored.AboutScreen();
  }
}
