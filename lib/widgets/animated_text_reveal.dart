import 'package:flutter/material.dart';

class AnimatedTextReveal extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration duration;
  final Duration delay;
  final Curve curve;
  final TextAlign textAlign;
  final bool animate;
  final StaggeredTextAnimation animationType;

  const AnimatedTextReveal({
    super.key,
    required this.text,
    this.style,
    this.duration = const Duration(milliseconds: 800),
    this.delay = Duration.zero,
    this.curve = Curves.easeInOut,
    this.textAlign = TextAlign.start,
    this.animate = true,
    this.animationType = StaggeredTextAnimation.fadeSlideUp,
  });

  @override
  State<AnimatedTextReveal> createState() => _AnimatedTextRevealState();
}

enum StaggeredTextAnimation {
  fadeSlideUp,
  fadeIn,
  typewriter,
  slideLeft,
  slideRight,
}

class _AnimatedTextRevealState extends State<AnimatedTextReveal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  String _visibleText = '';
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: widget.curve);

    Offset beginOffset;
    switch (widget.animationType) {
      case StaggeredTextAnimation.fadeSlideUp:
        beginOffset = const Offset(0.0, 0.5);
        break;
      case StaggeredTextAnimation.slideLeft:
        beginOffset = const Offset(-0.5, 0.0);
        break;
      case StaggeredTextAnimation.slideRight:
        beginOffset = const Offset(0.5, 0.0);
        break;
      default:
        beginOffset = Offset.zero;
        break;
    }

    _slideAnimation = Tween<Offset>(
      begin: beginOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    if (widget.animate) {
      Future.delayed(widget.delay, () {
        if (mounted) {
          if (widget.animationType == StaggeredTextAnimation.typewriter) {
            _animateTypewriter();
          } else {
            _controller.forward();
          }
        }
      });
    } else {
      _controller.value = 1.0;
      if (widget.animationType == StaggeredTextAnimation.typewriter) {
        _visibleText = widget.text;
      }
    }
  }

  void _animateTypewriter() {
    if (!mounted) return;

    setState(() {
      _visibleText = '';
      _isInitialized = true;
    });

    _controller.reset();
    _controller.duration = Duration(milliseconds: 50 * widget.text.length);

    Animation<int> typewriterAnimation = IntTween(
      begin: 0,
      end: widget.text.length,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    typewriterAnimation.addListener(() {
      if (mounted) {
        setState(() {
          _visibleText = widget.text.substring(0, typewriterAnimation.value);
        });
      }
    });

    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedTextReveal oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.text != oldWidget.text &&
        widget.animationType == StaggeredTextAnimation.typewriter) {
      _animateTypewriter();
    }

    if (widget.animate != oldWidget.animate) {
      if (widget.animate) {
        _controller.reset();
        Future.delayed(widget.delay, () {
          if (mounted) {
            if (widget.animationType == StaggeredTextAnimation.typewriter) {
              _animateTypewriter();
            } else {
              _controller.forward();
            }
          }
        });
      } else {
        _controller.value = 1.0;
        if (widget.animationType == StaggeredTextAnimation.typewriter) {
          setState(() {
            _visibleText = widget.text;
          });
        }
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
    if (widget.animationType == StaggeredTextAnimation.typewriter) {
      if (!_isInitialized && !widget.animate) {
        return Text(
          widget.text,
          style: widget.style,
          textAlign: widget.textAlign,
        );
      }

      return Text(
        _visibleText,
        style: widget.style,
        textAlign: widget.textAlign,
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        if (widget.animationType == StaggeredTextAnimation.fadeIn) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: Text(
              widget.text,
              style: widget.style,
              textAlign: widget.textAlign,
            ),
          );
        } else {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: Transform.translate(
              offset: Offset(
                _slideAnimation.value.dx * 20,
                _slideAnimation.value.dy * 20,
              ),
              child: Text(
                widget.text,
                style: widget.style,
                textAlign: widget.textAlign,
              ),
            ),
          );
        }
      },
    );
  }
}

// A widget that animates a list of text items with staggered timing
class StaggeredTextList extends StatefulWidget {
  final List<String> textItems;
  final TextStyle? style;
  final Duration itemDuration;
  final Duration staggerDuration;
  final Curve curve;
  final TextAlign textAlign;
  final bool animate;
  final StaggeredTextAnimation animationType;
  final double spacing;

  final AnimationController? sharedController;

  const StaggeredTextList({
    super.key,
    required this.textItems,
    this.style,
    this.itemDuration = const Duration(milliseconds: 800),
    this.staggerDuration = const Duration(milliseconds: 100),
    this.curve = Curves.easeInOut,
    this.textAlign = TextAlign.start,
    this.animate = true,
    this.animationType = StaggeredTextAnimation.fadeSlideUp,
    this.spacing = 8.0,
    this.sharedController,
  });

  @override
  State<StaggeredTextList> createState() => _StaggeredTextListState();
}

class _StaggeredTextListState extends State<StaggeredTextList>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.sharedController ??
        AnimationController(vsync: this, duration: widget.itemDuration);
  }

  @override
  void dispose() {
    if (widget.sharedController == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          widget.textAlign == TextAlign.start
              ? CrossAxisAlignment.start
              : widget.textAlign == TextAlign.end
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.center,
      children: List.generate(widget.textItems.length * 2 - 1, (index) {
        if (index.isOdd) {
          return SizedBox(height: widget.spacing);
        }

        final textIndex = index ~/ 2;
        return StaggeredTextItem(
          text: widget.textItems[textIndex],
          style: widget.style,
          animationType: widget.animationType,
          textAlign: widget.textAlign,
          animationController: _controller,
          delay: widget.staggerDuration * index,
          curve: widget.curve,
        );
      }),
    );
  }
}

class StaggeredTextItem extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final StaggeredTextAnimation animationType;
  final TextAlign textAlign;
  final AnimationController animationController;
  final Duration delay;
  final Curve curve;

  const StaggeredTextItem({
    super.key,
    required this.text,
    this.style,
    required this.animationType,
    required this.textAlign,
    required this.animationController,
    required this.delay,
    required this.curve,
  });

  @override
  Widget build(BuildContext context) {
    Animation<double> fadeAnimation = CurvedAnimation(
      parent: animationController,
      curve: curve,
    );

    Offset beginOffset;
    switch (animationType) {
      case StaggeredTextAnimation.fadeSlideUp:
        beginOffset = const Offset(0.0, 0.5);
        break;
      case StaggeredTextAnimation.slideLeft:
        beginOffset = const Offset(-0.5, 0.0);
        break;
      case StaggeredTextAnimation.slideRight:
        beginOffset = const Offset(0.5, 0.0);
        break;
      default:
        beginOffset = Offset.zero;
        break;
    }

    Animation<Offset> slideAnimation = Tween<Offset>(
      begin: beginOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: animationController, curve: curve));

    return FadeTransition(
      opacity: fadeAnimation,
      child: SlideTransition(
        position: slideAnimation,
        child: Text(text, style: style, textAlign: textAlign),
      ),
    );
  }
}
