import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A blurred circle that animates its position - optimized version
class AnimatedBlurredCircle extends StatefulWidget {
  final double size;
  final Color color;
  final Duration duration;

  const AnimatedBlurredCircle({
    super.key,
    required this.size,
    required this.color,
    required this.duration,
  });

  @override
  State<AnimatedBlurredCircle> createState() => _AnimatedBlurredCircleState();
}

class _AnimatedBlurredCircleState extends State<AnimatedBlurredCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _positionAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Use longer duration for smoother animation
    _controller = AnimationController(vsync: this, duration: widget.duration);

    // Create smooth circular motion with TweenSequence

    _positionAnimation = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: const Offset(0, 0),
          end: const Offset(15, 15),
        ).chain(CurveTween(curve: Curves.easeOutQuad)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: const Offset(15, 15),
          end: const Offset(15, -15),
        ).chain(CurveTween(curve: Curves.easeInOutQuad)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: const Offset(15, -15),
          end: const Offset(-15, -15),
        ).chain(CurveTween(curve: Curves.easeInOutQuad)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: const Offset(-15, -15),
          end: const Offset(0, 0),
        ).chain(CurveTween(curve: Curves.easeInQuad)),
        weight: 25,
      ),
    ]).animate(_controller);

    // Create smooth scaling animation
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 1.1,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.1,
          end: 0.95,
        ).chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.95,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeInCubic)),
        weight: 30,
      ),
    ]).animate(_controller);

    // Use repeat for continuous animation
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: _positionAnimation.value,
            child: Transform.scale(scale: _scaleAnimation.value, child: child),
          );
        },
        // Create the child once to avoid rebuilding it on every animation frame
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            // Use a gradient instead of backdrop filter for better performance
            gradient: RadialGradient(
              colors: [widget.color, widget.color.withAlpha(178)],
              stops: const [0.5, 1.0],
            ),
          ),
        ),
      ),
    );
  }
}

/// A rotating border animation
class RotatingBorder extends StatefulWidget {
  final Color color;
  final double width;

  const RotatingBorder({super.key, required this.color, required this.width});

  @override
  State<RotatingBorder> createState() => _RotatingBorderState();
}

class _RotatingBorderState extends State<RotatingBorder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    // Longer duration for smoother animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    );

    // Use cubic curve for smoother rotation
    _rotationAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _rotationAnimation,
        builder: (context, child) {
          return CustomPaint(
            painter: _RotatingBorderPainter(
              progress: _rotationAnimation.value,
              color: widget.color,
              strokeWidth: widget.width,
            ),
            size: const Size.fromRadius(
              150,
            ), // Fixed size for better performance
            child: Container(),
          );
        },
      ),
    );
  }
}

class _RotatingBorderPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  // Cache for better performance
  final Paint _paint =
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..isAntiAlias = true; // Enable anti-aliasing for smoother curves

  _RotatingBorderPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  }) {
    _paint.color = color;
    _paint.strokeWidth = strokeWidth;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    // Use path for more efficient drawing
    final path = Path();

    // Draw multiple arcs with different rotation speeds and offsets
    for (int i = 0; i < 3; i++) {
      // Calculate rotation with smooth easing
      final rotation =
          i % 2 == 0
              ? progress *
                  2 *
                  math
                      .pi // Clockwise
              : -progress * 2 * math.pi; // Counter-clockwise

      final startAngle = rotation + (i * math.pi / 1.5);
      final sweepAngle = math.pi * 0.6; // Longer arc for better visual

      // Add arc to path
      path.addArc(
        Rect.fromCircle(center: center, radius: radius - (i * 2)),
        startAngle,
        sweepAngle,
      );
    }

    // Draw the path once
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(_RotatingBorderPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }

  // Optimize semantics rebuilding
  @override
  bool shouldRebuildSemantics(_RotatingBorderPainter oldDelegate) => false;
}

/// A mesh grid painter - optimized version
class MeshPainter extends CustomPainter {
  final Color lineColor;
  final double lineWidth;
  final double gridSize;

  // Cache for better performance
  final Map<Size, List<Offset>> _linePointsCache = {};

  MeshPainter({
    required this.lineColor,
    required this.lineWidth,
    required this.gridSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = lineColor
          ..strokeWidth = lineWidth
          ..isAntiAlias = false; // Disable anti-aliasing for better performance

    // Use cached line points if available
    List<Offset> linePoints;
    if (_linePointsCache.containsKey(size)) {
      linePoints = _linePointsCache[size]!;
    } else {
      linePoints = _calculateLinePoints(size);
      _linePointsCache[size] = linePoints;
    }

    // Draw all lines at once using more efficient path drawing
    final path = Path();

    // Draw lines in pairs (start and end points)
    for (int i = 0; i < linePoints.length; i += 2) {
      path.moveTo(linePoints[i].dx, linePoints[i].dy);
      path.lineTo(linePoints[i + 1].dx, linePoints[i + 1].dy);
    }

    canvas.drawPath(path, paint);
  }

  List<Offset> _calculateLinePoints(Size size) {
    final List<Offset> points = [];

    // Calculate horizontal lines - use fewer lines for better performance
    final double yStep =
        gridSize * 2; // Double the spacing for better performance
    for (double y = 0; y < size.height; y += yStep) {
      points.add(Offset(0, y));
      points.add(Offset(size.width, y));
    }

    // Calculate vertical lines - use fewer lines for better performance
    final double xStep =
        gridSize * 2; // Double the spacing for better performance
    for (double x = 0; x < size.width; x += xStep) {
      points.add(Offset(x, 0));
      points.add(Offset(x, size.height));
    }

    return points;
  }

  @override
  bool shouldRepaint(MeshPainter oldDelegate) {
    return oldDelegate.lineColor != lineColor ||
        oldDelegate.lineWidth != lineWidth ||
        oldDelegate.gridSize != gridSize;
  }

  // Override shouldRebuildSemantics to return false for better performance
  @override
  bool shouldRebuildSemantics(CustomPainter oldDelegate) => false;
}

/// An animated skill tag that floats - optimized version
class AnimatedSkillTag extends StatefulWidget {
  final String skill;
  final Color color;
  final Duration delay;
  final AnimationController? animationController;

  const AnimatedSkillTag({
    super.key,
    required this.skill,
    required this.color,
    required this.delay,
    this.animationController,
  });

  @override
  State<AnimatedSkillTag> createState() => _AnimatedSkillTagState();
}

class _AnimatedSkillTagState extends State<AnimatedSkillTag>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late final Animation<Offset> _positionAnimation;
  late Animation<double> _scaleAnimation;

  // Cache the text style for better performance
  late final TextStyle _textStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 14, // Increased font size for better readability
    decoration: TextDecoration.none,
    letterSpacing: 0.5, // Added letter spacing for better readability
  );

  @override
  void initState() {
    super.initState();

    // Scale animation controller with different duration for more natural feel
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    // Create smooth position animation with Lissajous curve for more natural floating
    _positionAnimation = Tween<Offset>(
      begin: const Offset(-5, -5),
      end: const Offset(5, 5),
    ).animate(
      CurvedAnimation(
        parent:
            widget.animationController ?? _getDefaultPositionController()
              ..repeat(reverse: true),
        // Use custom curve for smoother, more natural floating motion
        curve: const _FloatingCurve(),
      ),
    );

    // Create smooth scale animation
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.97,
          end: 1.03,
        ).chain(CurveTween(curve: Curves.easeInOutSine)),
        weight: 1,
      ),
    ]).animate(_scaleController);

    // Delayed start with different timing for more natural feel
    Future.delayed(widget.delay, () {
      if (mounted) {
        // Slight delay for scale to create more organic motion
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            _scaleController.repeat(reverse: true);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  AnimationController _getDefaultPositionController() {
    final controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8), // Slower for smoother motion
    );
    return controller;
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: Listenable.merge([_positionAnimation, _scaleAnimation]),
        builder: (context, child) {
          return Transform.translate(
            offset: _positionAnimation.value,
            child: Transform.scale(scale: _scaleAnimation.value, child: child),
          );
        },
        // Create the child once
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: widget.color.withAlpha(200),
            borderRadius: BorderRadius.circular(20),
            // Use a simpler shadow for better performance
            boxShadow: [
              BoxShadow(
                color: widget.color.withAlpha(80),
                blurRadius: 4,
                spreadRadius: 0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          // Ensure text is properly sized and doesn't get cropped
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              widget.skill,
              style: _textStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

// Custom curve for more natural floating motion
class _FloatingCurve extends Curve {
  const _FloatingCurve();

  @override
  double transformInternal(double t) {
    // Use sine and cosine with different frequencies for more natural motion
    final x = math.sin(t * math.pi * 2);
    final y = math.cos(t * math.pi * 1.5);

    // Normalize to [0, 1] range
    return (x + y + 2) / 4;
  }
}

/// A text with animated gradient effect - optimized version
class AnimatedGradientText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final List<Color> colors;
  final Duration duration;

  const AnimatedGradientText({
    super.key,
    required this.text,
    required this.style,
    required this.colors,
    required this.duration,
  });

  @override
  State<AnimatedGradientText> createState() => _AnimatedGradientTextState();
}

class _AnimatedGradientTextState extends State<AnimatedGradientText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  // Cache the text style
  late final TextStyle _textStyle = widget.style.copyWith(
    color: Colors.white,
    decoration: TextDecoration.none,
  );

  @override
  void initState() {
    super.initState();

    // Use longer duration for smoother animation
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.duration.inMilliseconds * 2),
    );

    // Use a smoother curve for the rotation animation
    _rotationAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(
        parent: _controller,
        // Use a custom curve for smoother rotation
        curve: const _SmoothRotationCurve(),
      ),
    );

    // Slower animation for better performance
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _rotationAnimation,
        builder: (context, child) {
          return ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                colors: widget.colors,
                stops: const [0.0, 1.0], // Fixed stops for better performance
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                transform: GradientRotation(_rotationAnimation.value),
              ).createShader(bounds);
            },
            child: child,
          );
        },
        // Create the child once
        child: Text(widget.text, style: _textStyle),
      ),
    );
  }
}

// Custom curve for smoother rotation
class _SmoothRotationCurve extends Curve {
  const _SmoothRotationCurve();

  @override
  double transformInternal(double t) {
    // Use a sine function for smoother rotation
    return (1 - math.cos(t * math.pi)) / 2;
  }
}
