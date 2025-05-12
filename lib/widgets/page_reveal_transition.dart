import 'package:flutter/material.dart';
import 'dart:math' as math;

class PageRevealTransition extends StatefulWidget {
  final Widget child;
  final Color? revealColor;
  final Duration duration;
  final bool isRevealing;
  final VoidCallback? onTransitionComplete;
  final Curve curve;

  const PageRevealTransition({
    super.key,
    required this.child,
    this.revealColor,
    this.duration = const Duration(milliseconds: 800),
    this.isRevealing = true,
    this.onTransitionComplete,
    this.curve = Curves.easeInOutCubic,
  });

  @override
  State<PageRevealTransition> createState() => _PageRevealTransitionState();
}

class _PageRevealTransitionState extends State<PageRevealTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);

    if (widget.isRevealing) {
      _controller.forward().then((_) {
        if (widget.onTransitionComplete != null) {
          widget.onTransitionComplete!();
        }
      });
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(PageRevealTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRevealing != oldWidget.isRevealing) {
      if (widget.isRevealing) {
        _controller.forward().then((_) {
          if (widget.onTransitionComplete != null) {
            widget.onTransitionComplete!();
          }
        });
      } else {
        _controller.reverse().then((_) {
          if (widget.onTransitionComplete != null) {
            widget.onTransitionComplete!();
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // When fully revealed, don't use the clipper to avoid performance issues
    if (_animation.value >= 1.0) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Stack(
          children: [
            // The reveal color background
            Container(
              color:
                  widget.revealColor ?? Theme.of(context).colorScheme.primary,
            ),
            // The clipped content
            ClipPath(
              clipper: CircleRevealClipper(value: _animation.value),
              child: widget.child,
            ),
          ],
        );
      },
    );
  }
}

class CircleRevealClipper extends CustomClipper<Path> {
  final double value;
  double? _radius;

  CircleRevealClipper({required this.value});

  @override
  Path getClip(Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    _radius ??= math.sqrt(size.width * size.width + size.height * size.height);
    final double currentRadius = _radius! * value;

    final Path path = Path();

    if (value <= 0.0) {
      // Fully hidden - return empty path (nothing visible)
      return path;
    } else if (value >= 1.0) {
      // Fully revealed - show everything
      path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));
      return path;
    } else {
      // Revealing in progress - create a circular reveal
      path.addOval(
        Rect.fromCircle(
          center: Offset(centerX, centerY),
          radius: currentRadius,
        ),
      );
      return path;
    }
  }

  @override
  bool shouldReclip(CircleRevealClipper oldClipper) {
    return oldClipper.value != value;
  }
}

// A widget that reveals its child with a sliding animation
class SlideRevealTransition extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final bool isRevealing;
  final VoidCallback? onTransitionComplete;
  final Curve curve;
  final SlideDirection direction;

  const SlideRevealTransition({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 800),
    this.delay = Duration.zero,
    this.isRevealing = true,
    this.onTransitionComplete,
    this.curve = Curves.easeInOutCubic,
    this.direction = SlideDirection.up,
  });

  @override
  State<SlideRevealTransition> createState() => _SlideRevealTransitionState();
}

enum SlideDirection { up, down, left, right }

class _SlideRevealTransitionState extends State<SlideRevealTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    _updateSlideAnimation();

    if (widget.isRevealing) {
      if (widget.delay > Duration.zero) {
        Future.delayed(widget.delay, () {
          if (mounted) {
            _controller.forward().then((_) {
              if (widget.onTransitionComplete != null) {
                widget.onTransitionComplete!();
              }
            });
          }
        });
      } else {
        _controller.forward().then((_) {
          if (widget.onTransitionComplete != null) {
            widget.onTransitionComplete!();
          }
        });
      }
    } else {
      _controller.value = 1.0;
    }
  }

  void _updateSlideAnimation() {
    Offset beginOffset;

    switch (widget.direction) {
      case SlideDirection.up:
        beginOffset = const Offset(0.0, 1.0);
        break;
      case SlideDirection.down:
        beginOffset = const Offset(0.0, -1.0);
        break;
      case SlideDirection.left:
        beginOffset = const Offset(1.0, 0.0);
        break;
      case SlideDirection.right:
        beginOffset = const Offset(-1.0, 0.0);
        break;
    }

    _slideAnimation = Tween<Offset>(
      begin: beginOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));
  }

  @override
  void didUpdateWidget(SlideRevealTransition oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.direction != oldWidget.direction) {
      _updateSlideAnimation();
    }

    if (widget.isRevealing != oldWidget.isRevealing) {
      if (widget.isRevealing) {
        _controller.forward().then((_) {
          if (widget.onTransitionComplete != null) {
            widget.onTransitionComplete!();
          }
        });
      } else {
        _controller.reverse().then((_) {
          if (widget.onTransitionComplete != null) {
            widget.onTransitionComplete!();
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(position: _slideAnimation, child: widget.child);
  }
}
