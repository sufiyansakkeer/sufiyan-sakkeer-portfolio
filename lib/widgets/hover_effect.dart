import 'package:flutter/material.dart';
import 'package:portfolio/config/design_system.dart';

/// A widget that provides hover effects for its child
class HoverEffect extends StatefulWidget {
  final Widget child;
  final double scale;
  final bool enableScale;
  final bool enableElevation;
  final double elevationOnHover;
  final double defaultElevation;
  final Duration duration;
  final Curve curve;
  final Color? hoverColor;

  const HoverEffect({
    super.key,
    required this.child,
    this.scale = 1.05,
    this.enableScale = true,
    this.enableElevation = true,
    this.elevationOnHover = 4.0,
    this.defaultElevation = 1.0,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeInOut,
    this.hoverColor,
  });

  @override
  State<HoverEffect> createState() => _HoverEffectState();
}

class _HoverEffectState extends State<HoverEffect> {
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
                      blurRadius:
                          _isHovered
                              ? widget.elevationOnHover * 2
                              : widget.defaultElevation * 2,
                      spreadRadius: _isHovered ? 1 : 0,
                      offset: Offset(0, _isHovered ? 4 : 2),
                    ),
                  ],
                )
                : null,
        child:
            widget.hoverColor != null
                ? ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    _isHovered ? widget.hoverColor! : Colors.transparent,
                    BlendMode.srcATop,
                  ),
                  child: widget.child,
                )
                : widget.child,
      ),
    );
  }
}

/// A button with hover effects
class HoverButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? hoverColor;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final double elevation;
  final double hoverElevation;

  const HoverButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.backgroundColor,
    this.hoverColor,
    this.padding = const EdgeInsets.symmetric(
      horizontal: DesignSystem.spacingMd,
      vertical: DesignSystem.spacingSm,
    ),
    this.borderRadius = const BorderRadius.all(
      Radius.circular(DesignSystem.radiusSm),
    ),
    this.elevation = DesignSystem.elevationSm,
    this.hoverElevation = DesignSystem.elevationMd,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? theme.colorScheme.primary;
    final hvColor = hoverColor ?? bgColor.withAlpha(230);

    return HoverEffect(
      enableScale: false,
      elevationOnHover: hoverElevation,
      defaultElevation: elevation,
      child: Material(
        color: bgColor,
        borderRadius: borderRadius,
        child: InkWell(
          onTap: onPressed,
          borderRadius: borderRadius,
          hoverColor: hvColor,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
