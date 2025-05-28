import 'package:flutter/material.dart';
import 'package:portfolio/config/design_system.dart';
import 'package:portfolio/utils/animation_utilities.dart';
import 'package:portfolio/utils/helpers.dart';

/// A styled card with consistent design and hover effects
class StyledCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final bool enableHover;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final bool animate;
  final String? animationKey;
  final Offset? slideOffset;
  final BoxConstraints? constraints;
  final bool clipContent;
  final bool useGlassEffect;
  final double glassOpacity;

  const StyledCard({
    super.key,
    required this.child,
    this.padding,
    this.width,
    this.height,
    this.enableHover = true,
    this.onTap,
    this.borderRadius,
    this.backgroundColor,
    this.animate = false,
    this.animationKey,
    this.slideOffset,
    this.constraints,
    this.clipContent = true,
    this.useGlassEffect = false,
    this.glassOpacity = 0.7,
  });

  @override
  State<StyledCard> createState() => _StyledCardState();
}

class _StyledCardState extends State<StyledCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    // Base card content
    Widget content = Container(
      width: widget.width,
      height: widget.height,
      constraints: widget.constraints,
      decoration:
          widget.useGlassEffect
              ? DesignSystem.getGlassEffect(
                context,
                opacity: widget.glassOpacity,
              )
              : DesignSystem.getCardDecoration(
                context,
                isHovered: _isHovered && widget.enableHover,
              ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius:
              widget.borderRadius ??
              BorderRadius.circular(DesignSystem.radiusLg),
          splashColor:
              widget.onTap != null
                  ? Theme.of(context).colorScheme.primary.withAlpha(26)
                  : Colors.transparent,
          highlightColor:
              widget.onTap != null
                  ? Theme.of(context).colorScheme.primary.withAlpha(13)
                  : Colors.transparent,
          hoverColor:
              widget.onTap != null && widget.enableHover
                  ? Theme.of(context).colorScheme.primary.withAlpha(8)
                  : Colors.transparent,
          child: Padding(
            padding:
                widget.padding ?? const EdgeInsets.all(DesignSystem.spacingMd),
            child: widget.child,
          ),
        ),
      ),
    );

    // Apply clipping if requested
    if (widget.clipContent) {
      content = ClipRRect(
        borderRadius:
            widget.borderRadius ?? BorderRadius.circular(DesignSystem.radiusLg),
        child: content,
      );
    }

    // Apply hover effect if enabled
    if (widget.enableHover) {
      content = MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedScale(
          scale: _isHovered ? 1.02 : 1.0,
          duration: DesignSystem.durationFast,
          curve: DesignSystem.curveStandard,
          child: content,
        ),
      );
    }

    // Apply animation if requested
    if (widget.animate && widget.animationKey != null) {
      return AnimationUtilities.createVisibilityTriggeredAnimation(
        child: content,
        animationKey: 'styled-card-${widget.animationKey}',
        duration: DesignSystem.durationMedium,
        slideOffset: widget.slideOffset ?? const Offset(0, 0.1),
        rotateAngle: 0.005, // Add a small rotation for 3D effect
      );
    }

    return content;
  }
}

/// A styled project card with consistent design
class ProjectCard extends StatelessWidget {
  final String title;
  final String description;
  final String? imageUrl;
  final List<String> technologies;
  final VoidCallback? onTapGithub;
  final VoidCallback? onTapLiveDemo;
  final bool animate;
  final String? animationKey;
  final double? width;
  final double? height;

  const ProjectCard({
    super.key,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.technologies,
    this.onTapGithub,
    this.onTapLiveDemo,
    this.animate = true,
    this.animationKey,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = Helpers.isMobile(context);

    return StyledCard(
      width: width,
      height: height,
      animate: animate,
      animationKey: animationKey,
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(maxWidth: isMobile ? double.infinity : 350),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Project image
          if (imageUrl != null)
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(DesignSystem.radiusLg),
                topRight: Radius.circular(DesignSystem.radiusLg),
              ),
              child: Image.network(
                imageUrl!,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 180,
                    width: double.infinity,
                    color: Theme.of(context).colorScheme.primary.withAlpha(26),
                    child: const Center(child: Icon(Icons.image, size: 48)),
                  );
                },
              ),
            ),

          // Project details
          Padding(
            padding: const EdgeInsets.all(DesignSystem.spacingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: DesignSystem.spacingXs),

                // Description
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: DesignSystem.spacingMd),

                // Technologies
                Wrap(
                  spacing: DesignSystem.spacingXs,
                  runSpacing: DesignSystem.spacingXs,
                  children:
                      technologies.map((tech) {
                        return Chip(
                          label: Text(
                            tech,
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          padding: EdgeInsets.zero,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        );
                      }).toList(),
                ),

                const SizedBox(height: DesignSystem.spacingMd),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (onTapGithub != null)
                      _buildActionButton(
                        context,
                        'GitHub',
                        Icons.code,
                        onTapGithub!,
                      ),
                    if (onTapGithub != null && onTapLiveDemo != null)
                      const SizedBox(width: DesignSystem.spacingSm),
                    if (onTapLiveDemo != null)
                      _buildActionButton(
                        context,
                        'Live Demo',
                        Icons.open_in_new,
                        onTapLiveDemo!,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onTap,
  ) {
    return AnimationUtilities.createButtonPressAnimation(
      onPressed: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: DesignSystem.spacingSm,
          vertical: DesignSystem.spacingXs,
        ),
        decoration: DesignSystem.getButtonDecoration(context),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            const SizedBox(width: DesignSystem.spacingXs),
            Text(
              label,
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
          ],
        ),
      ),
    );
  }
}
