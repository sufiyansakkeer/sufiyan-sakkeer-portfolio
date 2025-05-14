import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:portfolio/config/design_system.dart';
import 'package:portfolio/utils/helpers.dart';

/// A widget that displays content in a glass-like card with backdrop filter effect.
class GlassCard extends StatelessWidget {
  final Widget child;

  const GlassCard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // On mobile, use a simpler card without backdrop filter for better performance
    if (Helpers.isMobile(context)) {
      return Container(
        padding: DesignSystem.getCardPadding(context),
        decoration: BoxDecoration(
          color: Theme.of(
            context,
          ).colorScheme.surface.withAlpha(230), // More opaque for mobile
          borderRadius: BorderRadius.circular(DesignSystem.radiusLg),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withAlpha(50),
            width: 1,
          ),
          // Simpler shadow for better performance
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withAlpha(15),
              blurRadius: 8,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: child,
      );
    }

    // On desktop, use the glass effect with backdrop filter
    return RepaintBoundary(
      // Add RepaintBoundary to isolate repainting
      child: ClipRRect(
        borderRadius: BorderRadius.circular(DesignSystem.radiusLg),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 8,
            sigmaY: 8,
          ), // Reduced blur for better performance
          child: Container(
            padding: DesignSystem.getCardPadding(context),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withAlpha(180),
              borderRadius: BorderRadius.circular(DesignSystem.radiusLg),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withAlpha(50),
                width: 1,
              ),
              // Simpler shadow for better performance
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withAlpha(15),
                  blurRadius: 10,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
