import 'package:flutter/material.dart';

class ParallaxEffect extends StatefulWidget {
  final Widget child;
  final double intensity;
  final bool enableMouseTracking;
  final bool enableScrollEffect;
  final Duration animationDuration;
  final Curve animationCurve;

  const ParallaxEffect({
    super.key,
    required this.child,
    this.intensity = 30.0,
    this.enableMouseTracking = true,
    this.enableScrollEffect = true,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeOutCubic,
  });

  @override
  State<ParallaxEffect> createState() => _ParallaxEffectState();
}

class _ParallaxEffectState extends State<ParallaxEffect>
    with SingleTickerProviderStateMixin {
  // Add TickerProvider
  // Target offset based on mouse/scroll, normalized (-1 to 1)
  Offset _targetNormalizedOffset = Offset.zero;
  // Current animated offset
  late Animation<Offset> _parallaxAnimation;
  late AnimationController _controller;

  final GlobalKey _containerKey = GlobalKey();
  Size _containerSize = Size.zero;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    // Initialize animation - starts at zero, will animate towards target
    _parallaxAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero, // Initial end target
    ).animate(
      CurvedAnimation(parent: _controller, curve: widget.animationCurve),
    );

    // Add listener to rebuild on animation ticks
    _controller.addListener(() {
      setState(() {}); // Rebuild for transform update
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateContainerSize();
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose controller
    super.dispose();
  }

  void _updateContainerSize() {
    final RenderBox? renderBox =
        _containerKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      setState(() {
        _containerSize = renderBox.size;
        // _containerPosition = renderBox.localToGlobal(Offset.zero);
      });
    }
  }

  void _updateMousePosition(PointerEvent event) {
    if (!_isHovering || _containerSize == Size.zero) return;

    // Calculate relative position within the container
    final RenderBox renderBox =
        _containerKey.currentContext!.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(event.position);

    // Normalize mouse position to -1 to 1 range
    final normalizedMouseX =
        (localPosition.dx.clamp(0, _containerSize.width) /
                _containerSize.width) *
            2 -
        1;
    final normalizedMouseY =
        (localPosition.dy.clamp(0, _containerSize.height) /
                _containerSize.height) *
            2 -
        1;

    // Update target based on mouse (keep scroll component from _targetNormalizedOffset.dy)
    // Pass doubles directly, not an Offset
    _updateTargetOffset(normalizedMouseX, normalizedMouseY);
  }

  void _handleScroll(ScrollNotification notification) {
    if (!widget.enableScrollEffect || !mounted) return;

    // Get scroll position relative to this widget's context if possible
    // This provides a more localized scroll effect if the widget is inside another scrollable
    final scrollableState = Scrollable.maybeOf(context);
    double scrollDelta = 0;
    if (scrollableState != null) {
      // Attempt to get position, might need adjustment based on scroll direction/axis
      // This is a simplified example; robust scroll parallax might need more context.
      scrollDelta = scrollableState.position.pixels;
      // Normalize scroll effect based on viewport or widget height (example)
      final viewportHeight = scrollableState.position.viewportDimension;
      final normalizedScroll = (scrollDelta / viewportHeight).clamp(-1.0, 1.0);
      _updateTargetOffset(
        _targetNormalizedOffset.dx,
        normalizedScroll,
      ); // Update only scroll component
    } else if (notification.metrics.axis == Axis.vertical) {
      // Fallback using global pixels if not in a Scrollable context
      scrollDelta = notification.metrics.pixels;
      // Simple normalization (adjust as needed)
      final normalizedScroll = (scrollDelta / 1000).clamp(
        -1.0,
        1.0,
      ); // Example normalization
      _updateTargetOffset(
        _targetNormalizedOffset.dx,
        normalizedScroll,
      ); // Update only scroll component
    }
  }

  // Update target offset and animate towards it
  void _updateTargetOffset(double targetNormX, double targetNormY) {
    final newTarget = Offset(
      widget.enableMouseTracking ? targetNormX : 0.0,
      widget.enableScrollEffect
          ? targetNormY
          : 0.0, // Combine scroll later if needed or adjust logic
    );

    if ((newTarget - _targetNormalizedOffset).distanceSquared > 0.0001) {
      // Only animate if target changed significantly
      final currentActualOffset =
          _parallaxAnimation.value; // Get current animation value
      _targetNormalizedOffset = newTarget;

      // Create a new animation tweening from current value to new target
      _parallaxAnimation = Tween<Offset>(
        begin:
            currentActualOffset, // Start from where the animation currently is
        end:
            _targetNormalizedOffset *
            widget.intensity, // Scale target by intensity
      ).animate(
        CurvedAnimation(parent: _controller, curve: widget.animationCurve),
      );

      _controller.forward(from: 0.0); // Start animation from beginning
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the current animated offset value
    final Offset currentOffset = _parallaxAnimation.value;

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollUpdateNotification ||
            notification is ScrollEndNotification) {
          _handleScroll(notification);
        }
        return false;
      },
      child: MouseRegion(
        onEnter: (event) {
          _updateContainerSize(); // Ensure size is up-to-date
          setState(() {
            _isHovering = true;
          });
          _updateMousePosition(event); // Update position on enter
        },
        onExit: (event) {
          setState(() {
            _isHovering = false;
          });
          _updateTargetOffset(
            0.0,
            _targetNormalizedOffset.dy,
          ); // Reset mouse component of target
        },
        onHover: widget.enableMouseTracking ? _updateMousePosition : null,
        child: Container(
          // Use a plain Container, transform is handled by Transform widget
          key: _containerKey,
          child: Transform(
            // Use Transform widget driven by animation
            transform:
                Matrix4.identity()
                  ..translate(currentOffset.dx, currentOffset.dy),
            alignment: FractionalOffset.center,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class ParallaxStack extends StatefulWidget {
  final List<Widget> children;
  final List<double> intensityFactors;
  final bool enableMouseTracking;
  final bool enableScrollEffect;
  final Duration animationDuration;
  final Curve animationCurve;

  const ParallaxStack({
    super.key,
    required this.children,
    required this.intensityFactors,
    this.enableMouseTracking = true,
    this.enableScrollEffect = true,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeOutCubic,
  }) : assert(
         children.length == intensityFactors.length,
         'Children and intensity factors must have the same length',
       );

  @override
  State<ParallaxStack> createState() => _ParallaxStackState();
}

class _ParallaxStackState extends State<ParallaxStack>
    with SingleTickerProviderStateMixin {
  // Add TickerProvider
  // Target offset based on mouse/scroll, normalized (-1 to 1)
  Offset _targetNormalizedOffset = Offset.zero;
  // Use a list of animations, one for each child
  late List<Animation<Offset>> _parallaxAnimations;
  late AnimationController _controller;

  final GlobalKey _containerKey = GlobalKey();
  Size _containerSize = Size.zero;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    // Initialize animations for each child
    _parallaxAnimations = List.generate(widget.children.length, (index) {
      return Tween<Offset>(begin: Offset.zero, end: Offset.zero).animate(
        CurvedAnimation(parent: _controller, curve: widget.animationCurve),
      );
    });

    // Add listener to rebuild on animation ticks
    _controller.addListener(() {
      setState(() {}); // Rebuild for transform update
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateContainerSize();
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose controller
    super.dispose();
  }

  void _updateContainerSize() {
    final RenderBox? renderBox =
        _containerKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      setState(() {
        _containerSize = renderBox.size;
      });
    }
  }

  void _updateMousePosition(PointerEvent event) {
    if (!_isHovering || _containerSize == Size.zero) return;

    // Calculate relative position within the container
    final RenderBox renderBox =
        _containerKey.currentContext!.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(event.position);

    // Normalize mouse position to -1 to 1 range
    final normalizedMouseX =
        (localPosition.dx.clamp(0, _containerSize.width) /
                _containerSize.width) *
            2 -
        1;
    final normalizedMouseY =
        (localPosition.dy.clamp(0, _containerSize.height) /
                _containerSize.height) *
            2 -
        1;

    // Update target based on mouse (keep scroll component from _targetNormalizedOffset.dy)
    _updateTargetOffset(
      normalizedMouseX,
      normalizedMouseY,
    ); // Pass doubles directly
  }

  void _handleScroll(ScrollNotification notification) {
    if (!widget.enableScrollEffect || !mounted) return;

    // Similar scroll handling as in ParallaxEffect, update target Y
    final scrollableState = Scrollable.maybeOf(context);
    double scrollDelta = 0;
    if (scrollableState != null) {
      scrollDelta = scrollableState.position.pixels;
      final viewportHeight = scrollableState.position.viewportDimension;
      final normalizedScroll = (scrollDelta / viewportHeight).clamp(-1.0, 1.0);
      _updateTargetOffset(_targetNormalizedOffset.dx, normalizedScroll);
    } else if (notification.metrics.axis == Axis.vertical) {
      scrollDelta = notification.metrics.pixels;
      final normalizedScroll = (scrollDelta / 1000).clamp(-1.0, 1.0);
      _updateTargetOffset(_targetNormalizedOffset.dx, normalizedScroll);
    }
  }

  // Update target offset and animate towards it for all children
  // Accepts normalized mouse X/Y. Scroll is handled separately if needed or combined here.
  void _updateTargetOffset(double targetNormMouseX, double targetNormMouseY) {
    // Combine mouse and potential scroll target
    // TODO: Refine how scroll target is integrated if needed
    final newTarget = Offset(
      widget.enableMouseTracking ? targetNormMouseX : 0.0,
      widget.enableMouseTracking
          ? targetNormMouseY
          : 0.0, // Using mouse Y for now
      // widget.enableScrollEffect ? _targetNormalizedOffset.dy : 0.0 // Example: Keep existing scroll Y
    );

    if ((newTarget - _targetNormalizedOffset).distanceSquared > 0.0001) {
      _targetNormalizedOffset = newTarget;

      // Create new animations for all children
      _parallaxAnimations = List.generate(widget.children.length, (index) {
        final currentActualOffset =
            _parallaxAnimations[index].value; // Get current animation value
        final intensity = widget.intensityFactors[index];
        return Tween<Offset>(
          begin: currentActualOffset,
          end: _targetNormalizedOffset * intensity, // Apply intensity per layer
        ).animate(
          CurvedAnimation(parent: _controller, curve: widget.animationCurve),
        );
      });

      _controller.forward(from: 0.0); // Start animation from beginning
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollUpdateNotification ||
            notification is ScrollEndNotification) {
          _handleScroll(notification);
        }
        return false;
      },
      child: MouseRegion(
        onEnter: (event) {
          _updateContainerSize();
          setState(() {
            _isHovering = true;
          });
          _updateMousePosition(event);
        },
        onExit: (event) {
          setState(() {
            _isHovering = false;
          });
          _updateTargetOffset(
            0.0,
            _targetNormalizedOffset.dy,
          ); // Reset mouse component
        },
        onHover: widget.enableMouseTracking ? _updateMousePosition : null,
        child: Container(
          key: _containerKey,
          child: Stack(
            children: List.generate(widget.children.length, (index) {
              // Get the current animated offset value for this layer
              final Offset currentOffset = _parallaxAnimations[index].value;

              return Transform(
                // Use Transform widget driven by animation
                transform:
                    Matrix4.identity()
                      ..translate(currentOffset.dx, currentOffset.dy),
                alignment: FractionalOffset.center,
                child: widget.children[index],
              );
            }),
          ),
        ),
      ),
    );
  }
}
