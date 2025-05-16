import 'package:flutter/material.dart';
import 'package:portfolio/config/design_system.dart';
import 'package:portfolio/utils/animation_utilities.dart';
import 'package:portfolio/utils/helpers.dart';

/// A reusable section header with consistent styling and animations
class SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool animate;
  final String? animationKey;
  final CrossAxisAlignment alignment;
  final EdgeInsetsGeometry? padding;

  const SectionHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.animate = true,
    this.animationKey,
    this.alignment = CrossAxisAlignment.center,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final headerContent = Column(
      crossAxisAlignment: alignment,
      children: [
        // Section title
        Text(
          title,
          style: DesignSystem.getSectionTitleStyle(context),
          textAlign:
              alignment == CrossAxisAlignment.center
                  ? TextAlign.center
                  : TextAlign.start,
        ),

        SizedBox(height: DesignSystem.spacingSm),

        // Section subtitle
        Text(
          subtitle,
          style: DesignSystem.getSectionSubtitleStyle(context),
          textAlign:
              alignment == CrossAxisAlignment.center
                  ? TextAlign.center
                  : TextAlign.start,
        ),
      ],
    );

    final content = Padding(
      padding: padding ?? DesignSystem.getHeadingSpacing(),
      child: headerContent,
    );

    // Apply animation if requested
    if (animate && animationKey != null) {
      return AnimationUtilities.createVisibilityTriggeredAnimation(
        child: content,
        animationKey: 'section-header-$animationKey',
        slideOffset: const Offset(0, 0.2),
        duration: DesignSystem.durationMedium,
      );
    }

    return content;
  }
}

/// A divider with consistent styling for section separation
class SectionDivider extends StatelessWidget {
  final double thickness;
  final double indent;
  final double endIndent;
  final Color? color;
  final bool animate;
  final String? animationKey;

  const SectionDivider({
    super.key,
    this.thickness = 1.0,
    this.indent = 0.0,
    this.endIndent = 0.0,
    this.color,
    this.animate = true,
    this.animationKey,
  });

  @override
  Widget build(BuildContext context) {
    final divider = Divider(
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
      color:
          color ??
          Theme.of(context).colorScheme.primary.withAlpha(51), // 0.2 opacity
    );

    // Apply animation if requested
    if (animate && animationKey != null) {
      return AnimationUtilities.createVisibilityTriggeredAnimation(
        child: divider,
        animationKey: 'section-divider-$animationKey',
        duration: DesignSystem.durationFast,
        delay: DesignSystem.delayShort,
      );
    }

    return divider;
  }
}

/// A container for section content with consistent styling
class SectionContainer extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final bool animate;
  final String? animationKey;
  final bool enableParallax;
  final double? minHeight;

  const SectionContainer({
    super.key,
    required this.child,
    this.backgroundColor,
    this.padding,
    this.animate = true,
    this.animationKey,
    this.enableParallax = false,
    this.minHeight,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate minimum height based on screen size
    final screenHeight = MediaQuery.of(context).size.height;
    final defaultMinHeight = minHeight ?? screenHeight * 0.8;

    final container = Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: defaultMinHeight),
      decoration: DesignSystem.getSectionDecoration(
        context,
        backgroundColor: backgroundColor,
      ),
      padding: padding ?? DesignSystem.getSectionPadding(context),
      child: Center(
        child: SizedBox(
          width: Helpers.getResponsiveWidth(context),
          child: child,
        ),
      ),
    );

    // Apply animation if requested
    if (animate && animationKey != null) {
      return AnimationUtilities.createVisibilityTriggeredAnimation(
        child: container,
        animationKey: 'section-container-$animationKey',
        duration: DesignSystem.durationSlow,
        visibilityThreshold: 0.05,
      );
    }

    return container;
  }
}
