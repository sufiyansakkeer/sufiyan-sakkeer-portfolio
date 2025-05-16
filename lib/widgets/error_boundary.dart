import 'package:flutter/material.dart';

/// A widget that catches errors in its child widget tree and displays a fallback UI.
/// This is useful for preventing the entire app from crashing when a single widget fails.
class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final Widget fallback;

  const ErrorBoundary({super.key, required this.child, required this.fallback});

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    // Reset error state when widget is initialized
    _hasError = false;
  }

  @override
  void didUpdateWidget(ErrorBoundary oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset error state when widget is updated with new child
    if (widget.child != oldWidget.child) {
      _hasError = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return widget.fallback;
    }

    // Use Builder to catch errors during build
    return Builder(
      builder: (context) {
        try {
          return widget.child;
        } catch (error, stackTrace) {
          // Mark as having error
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _hasError = true;
              });
            }
          });

          // Log the error
          FlutterError.reportError(
            FlutterErrorDetails(
              exception: error,
              stack: stackTrace,
              library: 'ErrorBoundary widget',
              context: ErrorDescription('building $widget'),
            ),
          );

          // Return the fallback widget immediately
          return widget.fallback;
        }
      },
    );
  }
}
