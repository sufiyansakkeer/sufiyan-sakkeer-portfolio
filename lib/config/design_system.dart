import 'package:flutter/material.dart';

/// A centralized design system for the portfolio app
/// Contains spacing, padding, animations, and other design constants
class DesignSystem {
  // Spacing constants
  static const double spacingXxs = 4.0;
  static const double spacingXs = 8.0;
  static const double spacingSm = 16.0;
  static const double spacingMd = 24.0;
  static const double spacingLg = 32.0;
  static const double spacingXl = 48.0;
  static const double spacingXxl = 64.0;

  // Border radius
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
  static const double radiusCircular = 100.0;

  // Elevation
  static const double elevationXs = 1.0;
  static const double elevationSm = 2.0;
  static const double elevationMd = 4.0;
  static const double elevationLg = 8.0;
  static const double elevationXl = 16.0;

  // Animation durations
  static const Duration durationFast = Duration(milliseconds: 200);
  static const Duration durationMedium = Duration(milliseconds: 350);
  static const Duration durationSlow = Duration(milliseconds: 500);

  // Animation curves
  static const Curve curveStandard = Curves.easeInOut;
  static const Curve curveAccelerate = Curves.easeIn;
  static const Curve curveDecelerate = Curves.easeOut;
  static const Curve curveSharp = Curves.easeInOutCubic;
  static const Curve curveElastic = Curves.elasticOut;

  // Responsive breakpoints
  static const double breakpointMobile = 600;
  static const double breakpointTablet = 1200;
  static const double breakpointDesktop = 1800;

  // Responsive padding
  static EdgeInsets getPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < breakpointMobile) {
      return const EdgeInsets.all(spacingSm);
    } else if (width < breakpointTablet) {
      return const EdgeInsets.all(spacingMd);
    } else {
      return const EdgeInsets.all(spacingLg);
    }
  }

  // Section padding
  static EdgeInsets getSectionPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < breakpointMobile) {
      return const EdgeInsets.symmetric(
        horizontal: spacingSm,
        vertical: spacingLg,
      );
    } else if (width < breakpointTablet) {
      return const EdgeInsets.symmetric(
        horizontal: spacingMd,
        vertical: spacingXl,
      );
    } else {
      return const EdgeInsets.symmetric(
        horizontal: spacingLg,
        vertical: spacingXxl,
      );
    }
  }

  // Card padding
  static EdgeInsets getCardPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < breakpointMobile) {
      return const EdgeInsets.all(spacingSm);
    } else {
      return const EdgeInsets.all(spacingMd);
    }
  }

  // Content width constraints
  static double getContentMaxWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < breakpointMobile) {
      return width * 0.95; // 95% of screen width
    } else if (width < breakpointTablet) {
      return width * 0.85; // 85% of screen width
    } else if (width < breakpointDesktop) {
      return width * 0.75; // 75% of screen width
    } else {
      return 1400; // Max fixed width
    }
  }

  // Button styles
  static ButtonStyle primaryButtonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(
        horizontal: spacingMd,
        vertical: spacingSm,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusSm),
      ),
    ).copyWith(
      elevation: WidgetStateProperty.resolveWith<double>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.hovered)) {
          return elevationMd;
        }
        return elevationSm;
      }),
      overlayColor: WidgetStateProperty.resolveWith<Color?>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.hovered)) {
          return Theme.of(
            context,
          ).colorScheme.primary.withAlpha(26); // 0.1 opacity
        }
        return null;
      }),
    );
  }

  // Card styles
  static CardTheme cardTheme(ColorScheme colorScheme) {
    return CardTheme(
      elevation: elevationSm,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusLg),
      ),
      clipBehavior: Clip.antiAlias,
      color: colorScheme.surface,
    );
  }
}
