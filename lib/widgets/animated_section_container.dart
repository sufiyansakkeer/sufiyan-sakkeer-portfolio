import 'package:flutter/material.dart';
import 'package:portfolio/utils/helpers.dart';
import 'package:portfolio/widgets/page_reveal_transition.dart';
import 'package:portfolio/widgets/parallax_effect.dart';
import 'package:portfolio/utils/animation_state_manager.dart';
import 'package:visibility_detector/visibility_detector.dart'; // Import the package
import 'package:portfolio/screens/projects_screen.dart';

class AnimatedSectionContainer extends StatefulWidget {
  final Widget child;
  final Color? backgroundColor;
  final Color? revealColor;
  final bool isActive;
  final bool enableParallax;
  final double parallaxIntensity;
  final Duration animationDuration;
  final Curve animationCurve;
  final EdgeInsetsGeometry? padding;
  final String? animationKey;

  const AnimatedSectionContainer({
    super.key,
    required this.child,
    this.backgroundColor,
    this.revealColor,
    this.isActive = false,
    this.enableParallax = true,
    this.parallaxIntensity = 20.0,
    this.animationDuration = const Duration(milliseconds: 800),
    this.animationCurve = Curves.easeInOutCubic,
    this.padding,
    this.animationKey,
  });

  @override
  State<AnimatedSectionContainer> createState() =>
      _AnimatedSectionContainerState();
}

class _AnimatedSectionContainerState extends State<AnimatedSectionContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  bool _isVisible = false;
  bool _hasRevealedOnce = false;

  // Key for VisibilityDetector
  final Key _visibilityKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    if (widget.isActive) {
      _controller.value = 1.0;
      _isVisible = true;
    }
  }

  @override
  void didUpdateWidget(AnimatedSectionContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleVisibilityChange(VisibilityInfo info) {
    // Use visibleFraction to determine visibility (e.g., > 0.1 means at least 10% visible)
    final bool isNowVisible = info.visibleFraction > 0.1 || widget.isActive;

    if (isNowVisible != _isVisible) {
      setState(() {
        _isVisible = isNowVisible;
        if (isNowVisible && !_hasRevealedOnce) {
          _hasRevealedOnce = true;
        }
      });

      if (isNowVisible) {
        _controller.forward();
      } else {
        // Only reverse if not explicitly active
        if (!widget.isActive) {
          _controller.reverse();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    final height = screenSize.height;
    final isLandscape = width > height;
    final safeAreaPadding = MediaQuery.of(context).padding;

    // Adjust min height for different screen orientations and devices
    double minHeight = height;

    // For landscape mode on mobile, reduce the minimum height requirement
    if (isLandscape && Helpers.isMobile(context)) {
      minHeight = height * 0.9; // 90% of screen height for landscape
    }

    // Account for safe area padding in height calculation
    minHeight -= (safeAreaPadding.top + safeAreaPadding.bottom);

    final content = Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: minHeight),
      padding: widget.padding ?? Helpers.getResponsivePadding(context),
      color: widget.backgroundColor,
      child: Center(
        child: SizedBox(
          width: Helpers.getResponsiveWidth(context),
          child:
              widget.enableParallax && !Helpers.isMobile(context)
                  ? ParallaxEffect(
                    intensity:
                        Helpers.isMobile(context)
                            ? widget.parallaxIntensity *
                                0.5 // Reduce intensity on mobile
                            : widget.parallaxIntensity,
                    enableScrollEffect: true,
                    enableMouseTracking:
                        !Helpers.isMobile(
                          context,
                        ), // Disable mouse tracking on mobile
                    animationDuration: const Duration(milliseconds: 200),
                    child: widget.child,
                  )
                  : widget.child,
        ),
      ),
    );

    // Check if we should reveal based on animation state
    bool shouldReveal = _isVisible;

    // If there's an animation key, check if it has already played
    if (widget.animationKey != null) {
      shouldReveal =
          _isVisible &&
          !animationStateManager.hasAnimationPlayed(widget.animationKey!);

      // If this is becoming visible and the animation hasn't played, mark it as played
      if (_isVisible &&
          !animationStateManager.hasAnimationPlayed(widget.animationKey!)) {
        // Mark as played once the animation starts
        animationStateManager.markAnimationPlayed(widget.animationKey!);
      }
    }
    // Wrap the animated content with VisibilityDetector
    return VisibilityDetector(
      key: _visibilityKey, // Use the unique key
      onVisibilityChanged: _handleVisibilityChange,
      child: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          if (_isVisible) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: PageRevealTransition(
                isRevealing: shouldReveal,
                duration: widget.animationDuration,
                curve: widget.animationCurve,
                revealColor: widget.revealColor,
                child: content,
              ),
            );
          } else {
            return Opacity(opacity: _fadeAnimation.value, child: content);
          }
        },
      ),
    );
  }
}

class AnimatedSectionStack extends StatefulWidget {
  final List<Widget> children;
  final List<Color>? backgroundColors;
  final List<Color>? revealColors;
  final int activeIndex;
  final bool enableParallax;
  final double parallaxIntensity;
  final Duration animationDuration;
  final Curve animationCurve;
  final EdgeInsetsGeometry? padding;
  final List<String>? animationKeys;

  const AnimatedSectionStack({
    super.key,
    required this.children,
    this.backgroundColors,
    this.revealColors,
    this.activeIndex = 0,
    this.enableParallax = true,
    this.parallaxIntensity = 20.0,
    this.animationDuration = const Duration(milliseconds: 800),
    this.animationCurve = Curves.easeInOutCubic,
    this.padding,
    this.animationKeys,
  });

  @override
  State<AnimatedSectionStack> createState() => _AnimatedSectionStackState();
}

class _AnimatedSectionStackState extends State<AnimatedSectionStack> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(widget.children.length, (index) {
        return AnimatedSectionContainer(
          isActive: index == widget.activeIndex,
          backgroundColor:
              widget.backgroundColors != null &&
                      widget.backgroundColors!.length > index
                  ? widget.backgroundColors![index]
                  : null,
          revealColor:
              widget.revealColors != null && widget.revealColors!.length > index
                  ? widget.revealColors![index]
                  : Theme.of(context).colorScheme.primary,
          enableParallax: widget.enableParallax,
          parallaxIntensity: widget.parallaxIntensity,
          animationDuration: widget.animationDuration,
          animationCurve: widget.animationCurve,
          padding: widget.padding,
          animationKey:
              widget.animationKeys != null &&
                      widget.animationKeys!.length > index
                  ? widget.animationKeys![index]
                  : null,
          child: widget.children[index],
        );
      }),
    );
  }
}
