import 'package:flutter/material.dart';

/// A centralized design system for the portfolio app
/// Contains spacing, padding, animations, and other design constants
class DesignSystem {
  // Spacing constants - consistent spacing throughout the app
  static const double spacingXxs = 4.0;
  static const double spacingXs = 8.0;
  static const double spacingSm = 16.0;
  static const double spacingMd = 24.0;
  static const double spacingLg = 32.0;
  static const double spacingXl = 48.0;
  static const double spacingXxl = 64.0;
  static const double spacingSection = 80.0; // For section separations

  // Border radius - consistent rounding of UI elements
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
  static const double radiusCircular = 100.0;

  // Elevation - consistent shadows and depth
  static const double elevationXs = 1.0;
  static const double elevationSm = 2.0;
  static const double elevationMd = 4.0;
  static const double elevationLg = 8.0;
  static const double elevationXl = 16.0;

  // Animation durations - consistent timing for animations
  static const Duration durationFast = Duration(milliseconds: 200);
  static const Duration durationMedium = Duration(milliseconds: 350);
  static const Duration durationSlow = Duration(milliseconds: 500);
  static const Duration durationVerySlow = Duration(milliseconds: 800);
  static const Duration durationVeryVerySlow = Duration(milliseconds: 1000);

  // Staggered animation delays
  static const Duration delayShort = Duration(milliseconds: 100);
  static const Duration delayMedium = Duration(milliseconds: 200);
  static const Duration delayLong = Duration(milliseconds: 300);

  // Animation curves - consistent easing for animations
  static const Curve curveStandard = Curves.easeInOut;
  static const Curve curveAccelerate = Curves.easeIn;
  static const Curve curveDecelerate = Curves.easeOut;
  static const Curve curveSharp = Curves.easeInOutCubic;
  static const Curve curveElastic = Curves.elasticOut;
  static const Curve curveSmooth = Curves.easeOutCubic; // Smoother animations

  // Opacity levels for consistent transparency
  static const double opacityDisabled = 0.38;
  static const double opacityLight = 0.5;
  static const double opacityMedium = 0.7;
  static const double opacityHigh = 0.9;

  // Responsive breakpoints - refined for better transitions
  static const double breakpointMobile =
      650; // Slightly increased for better mobile experience
  static const double breakpointTablet = 1200;
  static const double breakpointDesktop = 1800;

  // Responsive padding - improved for better spacing on mobile
  static EdgeInsets getPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final isLandscape = width > height;

    if (width < breakpointMobile) {
      // For very small devices or landscape mode on mobile, use smaller padding
      if (width < 400 || isLandscape) {
        return const EdgeInsets.symmetric(
          horizontal: spacingXs,
          vertical: spacingSm,
        );
      }
      return const EdgeInsets.symmetric(
        horizontal: spacingSm,
        vertical: spacingSm,
      );
    } else if (width < breakpointTablet) {
      return const EdgeInsets.all(spacingMd);
    } else {
      return const EdgeInsets.all(spacingLg);
    }
  }

  // Section padding - optimized for mobile
  static EdgeInsets getSectionPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final isLandscape = width > height;

    if (width < breakpointMobile) {
      // For very small devices or landscape mode, reduce vertical padding
      if (width < 400 || isLandscape) {
        return const EdgeInsets.symmetric(
          horizontal: spacingSm,
          vertical: spacingMd, // Reduced vertical padding for small screens
        );
      }
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

  // Card padding - optimized for different screen sizes
  static EdgeInsets getCardPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final isLandscape = width > height;

    if (width < breakpointMobile) {
      // For very small devices or landscape mode, use smaller padding
      if (width < 400 || isLandscape) {
        return const EdgeInsets.symmetric(
          horizontal: spacingSm,
          vertical: spacingXs,
        );
      }
      return const EdgeInsets.all(spacingSm);
    } else {
      return const EdgeInsets.all(spacingMd);
    }
  }

  // Content width constraints - optimized for better responsiveness
  static double getContentMaxWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final isLandscape = width > height;

    if (width < breakpointMobile) {
      // For very small devices or landscape mode, use more screen space
      if (width < 400 || isLandscape) {
        return width * 0.98; // 98% of screen width for small devices
      }
      return width * 0.95; // 95% of screen width
    } else if (width < breakpointTablet) {
      return width * 0.85; // 85% of screen width
    } else if (width < breakpointDesktop) {
      return width * 0.75; // 75% of screen width
    } else {
      return 1400; // Max fixed width
    }
  }

  // Get safe area padding for notched devices
  static EdgeInsets getSafeAreaPadding(BuildContext context) {
    return MediaQuery.of(context).padding;
  }

  // Get responsive font size
  static double getResponsiveFontSize(
    BuildContext context,
    double baseFontSize,
  ) {
    final width = MediaQuery.of(context).size.width;

    if (width < 360) {
      return baseFontSize * 0.8; // 80% of base size for very small screens
    } else if (width < breakpointMobile) {
      return baseFontSize * 0.9; // 90% of base size for mobile
    } else {
      return baseFontSize; // Base size for larger screens
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
  static CardThemeData cardTheme(ColorScheme colorScheme) {
    return CardThemeData(
      elevation: elevationSm,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusLg),
      ),
      clipBehavior: Clip.antiAlias,
      color: colorScheme.surface,
    );
  }

  // Section title styles - consistent heading styles across sections
  static TextStyle getSectionTitleStyle(BuildContext context) {
    return Theme.of(context).textTheme.displayMedium!.copyWith(
      fontWeight: FontWeight.bold,
      letterSpacing: -0.5,
    );
  }

  // Section subtitle styles
  static TextStyle getSectionSubtitleStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge!.copyWith(
      color: Theme.of(
        context,
      ).colorScheme.onSurface.withAlpha((opacityMedium * 255).round()),
    );
  }

  // Glass effect decoration - consistent glass effect across components
  static BoxDecoration getGlassEffect(
    BuildContext context, {
    double opacity = 0.7,
  }) {
    return BoxDecoration(
      color: Theme.of(
        context,
      ).colorScheme.surface.withAlpha((opacity * 255).round()),
      borderRadius: BorderRadius.circular(radiusMd),
      border: Border.all(
        color: Theme.of(
          context,
        ).colorScheme.primary.withAlpha(26), // 0.1 opacity
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(13), // 0.05 opacity
          blurRadius: 10,
          spreadRadius: 0,
        ),
      ],
    );
  }

  // Card decoration - consistent card styling
  static BoxDecoration getCardDecoration(
    BuildContext context, {
    bool isHovered = false,
  }) {
    return BoxDecoration(
      color: Theme.of(context).cardTheme.color,
      borderRadius: BorderRadius.circular(radiusLg),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(
            isHovered ? 26 : 13,
          ), // 0.1 or 0.05 opacity
          blurRadius: isHovered ? 15 : 10,
          spreadRadius: isHovered ? 1 : 0,
          offset: Offset(0, isHovered ? 5 : 2),
        ),
      ],
    );
  }

  // Button decoration - consistent button styling
  static BoxDecoration getButtonDecoration(
    BuildContext context, {
    bool isHovered = false,
    Color? backgroundColor,
  }) {
    final color = backgroundColor ?? Theme.of(context).colorScheme.primary;
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radiusSm),
      boxShadow: [
        BoxShadow(
          color: color.withAlpha(isHovered ? 77 : 51), // 0.3 or 0.2 opacity
          blurRadius: isHovered ? 8 : 4,
          spreadRadius: isHovered ? 1 : 0,
          offset: Offset(0, isHovered ? 3 : 1),
        ),
      ],
    );
  }

  // Section container decoration - consistent section styling
  static BoxDecoration getSectionDecoration(
    BuildContext context, {
    Color? backgroundColor,
  }) {
    return BoxDecoration(
      color: backgroundColor ?? Theme.of(context).colorScheme.surface,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(8), // 0.03 opacity
          blurRadius: 10,
          spreadRadius: 0,
        ),
      ],
    );
  }

  // Get consistent section spacing
  static EdgeInsets getSectionSpacing() {
    return const EdgeInsets.symmetric(vertical: spacingSection);
  }

  // Get consistent heading spacing
  static EdgeInsets getHeadingSpacing() {
    return const EdgeInsets.only(bottom: spacingLg);
  }
}
