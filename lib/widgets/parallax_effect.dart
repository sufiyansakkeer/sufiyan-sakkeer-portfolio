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

class _ParallaxEffectState extends State<ParallaxEffect> {
  Offset _mousePosition = Offset.zero;
  double _scrollOffset = 0.0;
  final GlobalKey _containerKey = GlobalKey();
  Size _containerSize = Size.zero;
  // Offset _containerPosition = Offset.zero;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateContainerSize();
    });
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
    if (!_isHovering) return;

    setState(() {
      // Calculate relative position within the container
      final RenderBox renderBox =
          _containerKey.currentContext!.findRenderObject() as RenderBox;
      final localPosition = renderBox.globalToLocal(event.position);

      // Normalize to -1 to 1 range
      _mousePosition = Offset(
        (localPosition.dx / _containerSize.width) * 2 - 1,
        (localPosition.dy / _containerSize.height) * 2 - 1,
      );
    });
  }

  void _handleScroll(double scrollOffset) {
    if (!widget.enableScrollEffect) return;

    setState(() {
      _scrollOffset = scrollOffset;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Calculate parallax offset based on mouse position and scroll
    final double mouseParallaxX =
        widget.enableMouseTracking ? _mousePosition.dx * widget.intensity : 0.0;
    final double mouseParallaxY =
        widget.enableMouseTracking ? _mousePosition.dy * widget.intensity : 0.0;

    // Calculate scroll-based parallax
    final double scrollParallaxY =
        widget.enableScrollEffect ? _scrollOffset * 0.5 : 0.0;

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollUpdateNotification) {
          _handleScroll(notification.metrics.pixels);
        }
        return false;
      },
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            _isHovering = true;
          });
          _updateContainerSize();
        },
        onExit: (_) {
          setState(() {
            _isHovering = false;
            _mousePosition = Offset.zero;
          });
        },
        onHover: widget.enableMouseTracking ? _updateMousePosition : null,
        child: Container(
          key: _containerKey,
          child: AnimatedContainer(
            duration: widget.animationDuration,
            curve: widget.animationCurve,
            transform:
                Matrix4.identity()
                  ..translate(mouseParallaxX, mouseParallaxY + scrollParallaxY),
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

class _ParallaxStackState extends State<ParallaxStack> {
  Offset _mousePosition = Offset.zero;
  double _scrollOffset = 0.0;
  final GlobalKey _containerKey = GlobalKey();
  Size _containerSize = Size.zero;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateContainerSize();
    });
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
    if (!_isHovering) return;

    setState(() {
      // Calculate relative position within the container
      final RenderBox renderBox =
          _containerKey.currentContext!.findRenderObject() as RenderBox;
      final localPosition = renderBox.globalToLocal(event.position);

      // Normalize to -1 to 1 range
      _mousePosition = Offset(
        (localPosition.dx / _containerSize.width) * 2 - 1,
        (localPosition.dy / _containerSize.height) * 2 - 1,
      );
    });
  }

  void _handleScroll(double scrollOffset) {
    if (!widget.enableScrollEffect) return;

    setState(() {
      _scrollOffset = scrollOffset;
    });
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollUpdateNotification) {
          _handleScroll(notification.metrics.pixels);
        }
        return false;
      },
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            _isHovering = true;
          });
          _updateContainerSize();
        },
        onExit: (_) {
          setState(() {
            _isHovering = false;
            _mousePosition = Offset.zero;
          });
        },
        onHover: widget.enableMouseTracking ? _updateMousePosition : null,
        child: Container(
          key: _containerKey,
          child: Stack(
            children: List.generate(widget.children.length, (index) {
              // Calculate parallax offset based on mouse position and scroll
              final double intensity = widget.intensityFactors[index];
              final double mouseParallaxX =
                  widget.enableMouseTracking
                      ? _mousePosition.dx * intensity
                      : 0.0;
              final double mouseParallaxY =
                  widget.enableMouseTracking
                      ? _mousePosition.dy * intensity
                      : 0.0;

              // Calculate scroll-based parallax
              final double scrollParallaxY =
                  widget.enableScrollEffect
                      ? _scrollOffset * (intensity * 0.02)
                      : 0.0;

              return AnimatedContainer(
                duration: widget.animationDuration,
                curve: widget.animationCurve,
                transform:
                    Matrix4.identity()..translate(
                      mouseParallaxX,
                      mouseParallaxY + scrollParallaxY,
                    ),
                child: widget.children[index],
              );
            }),
          ),
        ),
      ),
    );
  }
}
