import 'package:flutter/material.dart';
import 'package:portfolio/config/design_system.dart';
import 'package:portfolio/utils/animation_state_manager.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// A utility class for consistent animations throughout the app
class AnimationUtilities {
  /// Creates a fade-in animation that only triggers when the widget becomes visible
  static Widget createVisibilityTriggeredAnimation({
    required Widget child,
    required String animationKey,
    Duration duration = const Duration(milliseconds: 800),
    Duration delay = Duration.zero,
    Curve curve = DesignSystem.curveDecelerate,
    Offset? slideOffset,
    double? scaleStart,
    bool playOnce = true,
    double visibilityThreshold = 0.1,
  }) {
    return _VisibilityTriggeredAnimation(
      animationKey: animationKey,
      duration: duration,
      delay: delay,
      curve: curve,
      slideOffset: slideOffset,
      scaleStart: scaleStart,
      playOnce: playOnce,
      visibilityThreshold: visibilityThreshold,
      child: child,
    );
  }

  /// Creates a staggered animation for a list of children
  static List<Widget> createStaggeredAnimations({
    required List<Widget> children,
    required String baseAnimationKey,
    Duration baseDuration = const Duration(milliseconds: 600),
    Duration staggerDelay = const Duration(milliseconds: 100),
    Curve curve = DesignSystem.curveDecelerate,
    Offset? slideOffset,
    double? scaleStart,
    bool playOnce = true,
  }) {
    return List.generate(children.length, (index) {
      final delay = Duration(milliseconds: staggerDelay.inMilliseconds * index);
      final animationKey = '$baseAnimationKey-$index';

      return createVisibilityTriggeredAnimation(
        child: children[index],
        animationKey: animationKey,
        duration: baseDuration,
        delay: delay,
        curve: curve,
        slideOffset: slideOffset,
        scaleStart: scaleStart,
        playOnce: playOnce,
      );
    });
  }

  /// Creates a hover animation effect
  static Widget createHoverAnimation({
    required Widget child,
    double scale = 1.05,
    double elevation = 4.0,
    Duration duration = DesignSystem.durationFast,
    Curve curve = DesignSystem.curveStandard,
    Color? hoverColor,
    bool enableScale = true,
    bool enableElevation = true,
  }) {
    return _HoverAnimation(
      scale: scale,
      elevation: elevation,
      duration: duration,
      curve: curve,
      hoverColor: hoverColor,
      enableScale: enableScale,
      enableElevation: enableElevation,
      child: child,
    );
  }

  /// Creates a pulse animation effect
  static Widget createPulseAnimation({
    required Widget child,
    Duration duration = const Duration(milliseconds: 1500),
    double minScale = 0.97,
    double maxScale = 1.03,
    bool repeat = true,
    Curve curve = DesignSystem.curveSmooth,
  }) {
    return _PulseAnimation(
      duration: duration,
      minScale: minScale,
      maxScale: maxScale,
      repeat: repeat,
      curve: curve,
      child: child,
    );
  }

  /// Creates a button press animation
  static Widget createButtonPressAnimation({
    required Widget child,
    required VoidCallback onPressed,
    double pressedScale = 0.95,
    Duration duration = const Duration(milliseconds: 150),
    Curve curve = Curves.easeInOut,
  }) {
    return _ButtonPressAnimation(
      onPressed: onPressed,
      pressedScale: pressedScale,
      duration: duration,
      curve: curve,
      child: child,
    );
  }
}

/// A widget that animates its child when it becomes visible in the viewport
class _VisibilityTriggeredAnimation extends StatefulWidget {
  final Widget child;
  final String animationKey;
  final Duration duration;
  final Duration delay;
  final Curve curve;
  final Offset? slideOffset;
  final double? scaleStart;
  final bool playOnce;
  final double visibilityThreshold;

  const _VisibilityTriggeredAnimation({
    required this.child,
    required this.animationKey,
    this.duration = const Duration(milliseconds: 800),
    this.delay = Duration.zero,
    this.curve = DesignSystem.curveDecelerate,
    this.slideOffset,
    this.scaleStart,
    this.playOnce = true,
    this.visibilityThreshold = 0.1,
  });

  @override
  State<_VisibilityTriggeredAnimation> createState() =>
      _VisibilityTriggeredAnimationState();
}

class _VisibilityTriggeredAnimationState
    extends State<_VisibilityTriggeredAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  Animation<Offset>? _slideAnimation;
  Animation<double>? _scaleAnimation;
  bool _hasPlayed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    if (widget.slideOffset != null) {
      _slideAnimation = Tween<Offset>(
        begin: widget.slideOffset,
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));
    }

    if (widget.scaleStart != null) {
      _scaleAnimation = Tween<double>(
        begin: widget.scaleStart,
        end: 1.0,
      ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));
    }

    // Check if this animation has already played
    if (widget.playOnce) {
      _hasPlayed = animationStateManager.hasAnimationPlayed(
        widget.animationKey,
      );
      if (_hasPlayed) {
        _controller.value = 1.0; // Set to end state if already played
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction > widget.visibilityThreshold) {
      if (!_hasPlayed) {
        Future.delayed(widget.delay, () {
          if (mounted) {
            _controller.forward();
            if (widget.playOnce) {
              animationStateManager.markAnimationPlayed(widget.animationKey);
              _hasPlayed = true;
            }
          }
        });
      }
    } else if (!widget.playOnce &&
        _controller.status == AnimationStatus.completed) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('visibility-${widget.animationKey}'),
      onVisibilityChanged: _handleVisibilityChanged,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          Widget result = FadeTransition(opacity: _fadeAnimation, child: child);

          if (_slideAnimation != null) {
            result = SlideTransition(position: _slideAnimation!, child: result);
          }

          if (_scaleAnimation != null) {
            result = ScaleTransition(scale: _scaleAnimation!, child: result);
          }

          return result;
        },
        child: widget.child,
      ),
    );
  }
}

/// A widget that applies hover animations to its child
class _HoverAnimation extends StatefulWidget {
  final Widget child;
  final double scale;
  final double elevation;
  final Duration duration;
  final Curve curve;
  final Color? hoverColor;
  final bool enableScale;
  final bool enableElevation;

  const _HoverAnimation({
    required this.child,
    this.scale = 1.05,
    this.elevation = 4.0,
    this.duration = DesignSystem.durationFast,
    this.curve = DesignSystem.curveStandard,
    this.hoverColor,
    this.enableScale = true,
    this.enableElevation = true,
  });

  @override
  State<_HoverAnimation> createState() => _HoverAnimationState();
}

class _HoverAnimationState extends State<_HoverAnimation> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: widget.duration,
        curve: widget.curve,
        transform:
            Matrix4.identity()
              ..scale(widget.enableScale && _isHovered ? widget.scale : 1.0),
        decoration:
            widget.enableElevation
                ? BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(_isHovered ? 40 : 20),
                      blurRadius: _isHovered ? widget.elevation * 2 : 0,
                      spreadRadius: _isHovered ? 1 : 0,
                      offset: Offset(0, _isHovered ? 2 : 0),
                    ),
                  ],
                )
                : null,
        child: widget.child,
      ),
    );
  }
}

/// A widget that applies a pulsing animation to its child
class _PulseAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double minScale;
  final double maxScale;
  final bool repeat;
  final Curve curve;

  const _PulseAnimation({
    required this.child,
    this.duration = const Duration(milliseconds: 1500),
    this.minScale = 0.97,
    this.maxScale = 1.03,
    this.repeat = true,
    this.curve = DesignSystem.curveSmooth,
  });

  @override
  State<_PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<_PulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: widget.maxScale,
        ).chain(CurveTween(curve: widget.curve)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: widget.maxScale,
          end: widget.minScale,
        ).chain(CurveTween(curve: widget.curve)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: widget.minScale,
          end: 1.0,
        ).chain(CurveTween(curve: widget.curve)),
        weight: 1,
      ),
    ]).animate(_controller);

    if (widget.repeat) {
      _controller.repeat();
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(scale: _scaleAnimation.value, child: child);
      },
      child: widget.child,
    );
  }
}

/// A widget that applies a press animation to buttons
class _ButtonPressAnimation extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final double pressedScale;
  final Duration duration;
  final Curve curve;

  const _ButtonPressAnimation({
    required this.child,
    required this.onPressed,
    this.pressedScale = 0.95,
    this.duration = const Duration(milliseconds: 150),
    this.curve = Curves.easeInOut,
  });

  @override
  State<_ButtonPressAnimation> createState() => _ButtonPressAnimationState();
}

class _ButtonPressAnimationState extends State<_ButtonPressAnimation> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? widget.pressedScale : 1.0,
        duration: widget.duration,
        curve: widget.curve,
        child: widget.child,
      ),
    );
  }
}
