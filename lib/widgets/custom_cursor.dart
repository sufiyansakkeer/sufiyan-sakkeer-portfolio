import 'package:flutter/material.dart';
import 'package:portfolio/config/design_system.dart';

class CustomCursor extends StatefulWidget {
  final Widget child;
  final Color? cursorColor;
  final double size;
  final double hoverSize;
  final Duration animationDuration;
  final bool enabled;

  const CustomCursor({
    super.key,
    required this.child,
    this.cursorColor,
    this.size = 15.0,
    this.hoverSize = 30.0,
    this.animationDuration = const Duration(milliseconds: 150),
    this.enabled = true,
  });

  @override
  State<CustomCursor> createState() => _CustomCursorState();
}

class _CustomCursorState extends State<CustomCursor>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  Offset _position = Offset.zero;
  bool _isHovering = false;
  bool _isPointerDown = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _updateCursorPosition(PointerEvent event) {
    setState(() {
      _position = event.position;
    });
  }

  void _handleHoverChange(bool hovering) {
    setState(() {
      _isHovering = hovering;
    });
    if (hovering) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Only show custom cursor on desktop/web or when enabled
    final bool isMobile =
        MediaQuery.of(context).size.width < DesignSystem.breakpointMobile;

    if (isMobile || !widget.enabled) {
      return widget.child;
    }

    return MouseRegion(
      onHover: (event) {
        _updateCursorPosition(event);
      },
      cursor: SystemMouseCursors.none, // Hide the system cursor
      child: Stack(
        children: [
          Listener(
            onPointerDown: (event) {
              _updateCursorPosition(event);
              setState(() {
                _isPointerDown = true;
              });
            },
            onPointerUp: (event) {
              _updateCursorPosition(event);
              setState(() {
                _isPointerDown = false;
              });
            },
            onPointerMove: (event) {
              _updateCursorPosition(event);
            },
            onPointerHover: (event) {
              _updateCursorPosition(event);
            },
            child: Stack(
              children: [
                // The actual content
                HoverDetector(
                  onHoverChanged: _handleHoverChange,
                  child: widget.child,
                ),
              ],
            ),
          ),
          // Custom cursor
          if (_position !=
              Offset.zero) // Only show cursor when position is updated
            Positioned(
              left: _position.dx - (widget.size / 2),
              top: _position.dy - (widget.size / 2),
              child: IgnorePointer(
                child: AnimatedContainer(
                  duration: widget.animationDuration,
                  width: _isHovering ? widget.hoverSize : widget.size,
                  height: _isHovering ? widget.hoverSize : widget.size,
                  decoration: BoxDecoration(
                    color:
                        _isPointerDown
                            ? (widget.cursorColor ??
                                    Theme.of(context).colorScheme.primary)
                                .withAlpha(128) // 0.5 opacity
                            : (widget.cursorColor ??
                                    Theme.of(context).colorScheme.primary)
                                .withAlpha(77), // 0.3 opacity
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (widget.cursorColor ??
                                Theme.of(context).colorScheme.primary)
                            .withAlpha(51), // 0.2 opacity
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  transform:
                      Matrix4.identity()..translate(
                        _isPointerDown ? -2.0 : 0.0,
                        _isPointerDown ? -2.0 : 0.0,
                      ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class HoverDetector extends StatefulWidget {
  final Widget child;
  final Function(bool) onHoverChanged;

  const HoverDetector({
    super.key,
    required this.child,
    required this.onHoverChanged,
  });

  @override
  State<HoverDetector> createState() => _HoverDetectorState();
}

class _HoverDetectorState extends State<HoverDetector> {
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => widget.onHoverChanged(true),
      onExit: (_) => widget.onHoverChanged(false),
      child: widget.child,
    );
  }
}
