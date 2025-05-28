import 'package:flutter/material.dart';
import 'package:portfolio/config/design_system.dart';

enum CursorType { defaultCursor, pointer, text, grab }

class CustomCursor extends StatefulWidget {
  final Widget child;
  final Color? cursorColor;
  final CursorType cursorType;
  final double size;
  final double hoverSize;
  final Duration animationDuration;
  final bool enabled;

  const CustomCursor({
    super.key,
    required this.child,
    this.cursorColor,
    this.cursorType = CursorType.defaultCursor,
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
  final ValueNotifier<Offset> _position = ValueNotifier(Offset.zero);
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
    _position.dispose();
    super.dispose();
  }

  void _updateCursorPosition(PointerEvent event) {
    if ((event.position - _position.value).distance > 1.0) {
      _position.value = event.position;
    }
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

    return Stack(
      children: [
        MouseRegion(
          onHover: (event) {
            _updateCursorPosition(event);
          },
          cursor: SystemMouseCursors.none,
          child: Listener(
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
            child: CustomCursorWrapper(
              cursorType: widget.cursorType,
              child: HoverDetector(
                onHoverChanged: _handleHoverChange,
                child: widget.child,
              ),
            ),
          ),
        ),
        ValueListenableBuilder<Offset>(
          valueListenable: _position,
          builder: (context, position, child) {
            if (position == Offset.zero) {
              return const SizedBox.shrink();
            }

            return Positioned(
              left: position.dx - (widget.size / 2),
              top: position.dy - (widget.size / 2),
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
                                .withAlpha(128)
                            : (widget.cursorColor ??
                                    Theme.of(context).colorScheme.primary)
                                .withAlpha(77),
                    shape: _getCursorShape(widget.cursorType),
                    boxShadow: [
                      BoxShadow(
                        color: (widget.cursorColor ??
                                Theme.of(context).colorScheme.primary)
                            .withAlpha(51),
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
            );
          },
        ),
      ],
    );
  }

  BoxShape _getCursorShape(CursorType cursorType) {
    switch (cursorType) {
      case CursorType.defaultCursor:
        return BoxShape.circle;
      case CursorType.pointer:
        return BoxShape.rectangle;
      case CursorType.text:
        return BoxShape.circle;
      case CursorType.grab:
        return BoxShape.circle;
    }
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

class CustomCursorWrapper extends StatelessWidget {
  final Widget child;
  final CursorType cursorType;

  const CustomCursorWrapper({
    super.key,
    required this.child,
    required this.cursorType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(child: child);
  }
}
