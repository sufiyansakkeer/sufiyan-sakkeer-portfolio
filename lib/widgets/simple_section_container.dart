import 'package:flutter/material.dart';
import 'package:portfolio/utils/helpers.dart';

class SimpleSectionContainer extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final double? childWidth;
  final bool removeOnlyBottomPadding;
  const SimpleSectionContainer({
    super.key,
    required this.child,
    this.backgroundColor,
    this.padding,
    this.childWidth,
    this.removeOnlyBottomPadding = false,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    final height = screenSize.height;
    final isLandscape = width > height;
    final safeAreaPadding = MediaQuery.of(context).padding;

    // Calculate minimum height based on screen orientation
    double minHeight =
        Helpers.isMobile(context) && isLandscape
            ? height *
                0.9 // 90% of screen height for landscape on mobile
            : height;

    // Account for safe area padding in height calculation
    if (removeOnlyBottomPadding) {
      minHeight += safeAreaPadding.bottom;
    } else {
      minHeight -= (safeAreaPadding.top + safeAreaPadding.bottom);
    }

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: minHeight),
      padding: padding ?? Helpers.getResponsivePadding(context),
      color: backgroundColor,
      child: Center(
        child: SizedBox(
          width: childWidth ?? Helpers.getResponsiveWidth(context),
          child: child,
        ),
      ),
    );
  }
}
