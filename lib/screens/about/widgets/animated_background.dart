import 'package:flutter/material.dart';
import 'package:portfolio/widgets/animated_components.dart';

/// A widget that displays an animated background with blurred circles and a mesh overlay.
class AnimatedBackground extends StatelessWidget {
  const AnimatedBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: RepaintBoundary(
        // Add RepaintBoundary to isolate repainting
        child: Stack(
          children: [
            // Gradient background
            Positioned.fill(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.surface,
                      Theme.of(context).colorScheme.primary.withAlpha(15),
                    ],
                  ),
                ),
              ),
            ),

            // Animated circles - reduced to 3 for better performance
            ...List.generate(3, (index) {
              final size = 120.0 + (index * 60.0);
              final position = _getRandomPosition(index, context);
              final color = _getColorForIndex(index, context);

              return Positioned(
                left: position.dx,
                top: position.dy,
                child: AnimatedBlurredCircle(
                  size: size,
                  color: color,
                  // Slower animations for better performance
                  duration: Duration(milliseconds: 12000 + (index * 3000)),
                ),
              );
            }),

            // Mesh overlay - only show on desktop for better performance
            if (!_isMobile(context))
              Positioned.fill(
                child: CustomPaint(
                  painter: MeshPainter(
                    lineColor: Theme.of(
                      context,
                    ).colorScheme.primary.withAlpha(10),
                    lineWidth: 0.5,
                    gridSize: 60, // Increased grid size for better performance
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Offset _getRandomPosition(int index, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Create deterministic but seemingly random positions
    final positions = [
      Offset(-50, screenHeight * 0.2),
      Offset(screenWidth * 0.8, -80),
      Offset(screenWidth * 0.1, screenHeight * 0.8),
      Offset(screenWidth * 0.7, screenHeight * 0.7),
      Offset(screenWidth * 0.5, screenHeight * 0.3),
    ];

    return positions[index % positions.length];
  }

  Color _getColorForIndex(int index, BuildContext context) {
    final colors = [
      Theme.of(context).colorScheme.primary.withAlpha(40),
      Theme.of(context).colorScheme.secondary.withAlpha(30),
      Theme.of(context).colorScheme.tertiary.withAlpha(25),
      Theme.of(context).colorScheme.primary.withAlpha(20),
      Theme.of(context).colorScheme.secondary.withAlpha(15),
    ];

    return colors[index % colors.length];
  }

  bool _isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 650;
  }
}
