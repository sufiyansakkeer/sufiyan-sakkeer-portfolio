import 'package:flutter/material.dart';
import 'package:portfolio/config/design_system.dart';
import 'package:portfolio/widgets/error_boundary.dart';

/// A container widget that provides proper layout constraints for project views
/// This helps prevent layout overflow issues by enforcing proper constraints
class ProjectsLayoutContainer extends StatelessWidget {
  final Widget child;
  final String title;

  const ProjectsLayoutContainer({
    super.key,
    required this.child,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < 600;

    return ErrorBoundary(
      fallback: Container(
        height: 400,
        padding: const EdgeInsets.all(DesignSystem.spacingMd),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 40),
            const SizedBox(height: DesignSystem.spacingMd),
            Text(
              'Error rendering $title',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: DesignSystem.spacingMd),
            Text(
              'There was a problem with the layout. Please try refreshing the page.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Handle both width and height constraints properly
          final safeWidth =
              constraints.hasInfiniteWidth
                  ? screenSize.width
                  : constraints.maxWidth;

          // Handle infinite height constraints by using a fixed height
          final safeHeight =
              constraints.hasInfiniteHeight
                  ? screenSize.height *
                      0.7 // Fallback to 70% of screen height
                  : constraints.maxHeight.isFinite
                  ? constraints.maxHeight
                  : screenSize.height * 0.7;

          // Calculate appropriate dimensions based on available space
          final containerHeight =
              safeHeight.isFinite ? safeHeight : screenSize.height * 0.7;
          final contentHeight =
              isMobile ? containerHeight * 0.9 : containerHeight * 0.95;

          return Container(
            // Apply explicit constraints to prevent overflow
            constraints: BoxConstraints(
              maxWidth: safeWidth,
              maxHeight: containerHeight,
              // Add minimum constraints to ensure the container has some size
              minHeight: 300,
              minWidth: 300,
            ),
            // Use ClipRect to prevent overflow
            child: ClipRect(
              child: Material(
                color: Colors.transparent,
                // Use a simple container with fixed dimensions
                child: SizedBox(
                  width: safeWidth,
                  height: contentHeight,
                  // Directly use the child without additional wrappers
                  child: child,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
