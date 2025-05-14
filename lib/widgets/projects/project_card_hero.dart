import 'package:flutter/material.dart';
import 'dart:ui' show lerpDouble;
import 'package:portfolio/config/design_system.dart';
import 'package:portfolio/models/project.dart';
import 'package:portfolio/utils/animation_utilities.dart';
import 'package:portfolio/utils/helpers.dart';
import 'package:portfolio/widgets/styled_card.dart';

/// A wrapper widget that adds Hero animation capabilities to project cards
/// for smooth transitions between stack and grid views
class ProjectCardHero extends StatelessWidget {
  final Project project;
  final String heroTag;
  final double? width;
  final bool isGridView;
  final bool isActive;
  final bool animate;
  final String? animationKey;
  final Duration? animationDuration;
  final Curve? animationCurve;
  final VoidCallback? onTap;

  const ProjectCardHero({
    super.key,
    required this.project,
    required this.heroTag,
    this.width,
    this.isGridView = false,
    this.isActive = false,
    this.animate = true,
    this.animationKey,
    this.animationDuration,
    this.animationCurve,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Use Hero widget for smooth transitions between layouts
    return Hero(
      tag: heroTag,
      flightShuttleBuilder: (
        BuildContext flightContext,
        Animation<double> animation,
        HeroFlightDirection flightDirection,
        BuildContext fromHeroContext,
        BuildContext toHeroContext,
      ) {
        // Determine which card style to use during flight
        final bool toGrid = flightDirection == HeroFlightDirection.push;

        // Create a custom flight shuttle that morphs between the two card styles
        return Material(
          color: Colors.transparent,
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              // Use a custom transition that morphs between grid and stack cards
              return _buildTransitionCard(
                context,
                animation.value,
                toGrid: toGrid,
              );
            },
          ),
        );
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(DesignSystem.radiusLg),
          splashColor:
              onTap != null
                  ? Theme.of(context).colorScheme.primary.withAlpha(26)
                  : Colors.transparent,
          highlightColor:
              onTap != null
                  ? Theme.of(context).colorScheme.primary.withAlpha(13)
                  : Colors.transparent,
          child: _buildCard(context),
        ),
      ),
    );
  }

  // Build a transitioning card for the hero animation with ultra-smooth transitions
  Widget _buildTransitionCard(
    BuildContext context,
    double animationValue, {
    bool toGrid = false,
  }) {
    final isMobile = Helpers.isMobile(context);

    // Apply a custom curve to make the animation feel more natural
    // This creates a slight ease-in-out effect that feels more polished
    final curvedAnimValue = Curves.easeOutCubic.transform(animationValue);

    // Interpolate values between stack and grid card styles with smoother transitions
    final double imageHeight =
        lerpDouble(
          isMobile ? 180 : 180,
          isMobile ? 140 : 150,
          toGrid ? curvedAnimValue : 1 - curvedAnimValue,
        )!;

    // Smoothly interpolate text styles for a more refined transition
    final titleStyle = TextStyle.lerp(
      Theme.of(context).textTheme.headlineMedium,
      Theme.of(context).textTheme.titleLarge,
      toGrid ? curvedAnimValue : 1 - curvedAnimValue,
    );

    final descriptionStyle = TextStyle.lerp(
      Theme.of(context).textTheme.bodyMedium,
      Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontSize: isMobile ? 13 : 14,
        height: 1.4, // Slightly adjusted line height for better readability
      ),
      toGrid ? curvedAnimValue : 1 - curvedAnimValue,
    );

    // Create a card that morphs between the two styles with enhanced visual effects
    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(DesignSystem.radiusLg),
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius:
                lerpDouble(
                  10,
                  15,
                  toGrid ? curvedAnimValue : 1 - curvedAnimValue,
                )!,
            spreadRadius:
                lerpDouble(
                  0,
                  1,
                  toGrid ? curvedAnimValue : 1 - curvedAnimValue,
                )!,
            offset: Offset(
              0,
              lerpDouble(5, 3, toGrid ? curvedAnimValue : 1 - curvedAnimValue)!,
            ),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Project image with enhanced transitions
          AnimatedContainer(
            duration: const Duration(
              milliseconds: 100,
            ), // Quick micro-animation for smoother feel
            height: imageHeight,
            width: double.infinity,
            child: Image.network(
              project.imageUrl,
              height: imageHeight,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: imageHeight,
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
                  project.title,
                  style: titleStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: DesignSystem.spacingXs),

                // Description
                Text(
                  project.description,
                  style: descriptionStyle,
                  maxLines: isMobile ? 3 : 4,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: DesignSystem.spacingMd),

                // Technologies
                Wrap(
                  spacing: DesignSystem.spacingXs,
                  runSpacing: DesignSystem.spacingXs,
                  children:
                      project.technologies
                          .take(isGridView || toGrid ? 4 : 6)
                          .map((tech) {
                            return Chip(
                              label: Text(
                                tech,
                                style: TextStyle(
                                  fontSize:
                                      lerpDouble(
                                        12,
                                        10,
                                        toGrid
                                            ? curvedAnimValue
                                            : 1 - curvedAnimValue,
                                      )!,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              padding: EdgeInsets.zero,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                            );
                          })
                          .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    if (isGridView) {
      return _buildGridCard(context);
    } else {
      return _buildStackCard(context);
    }
  }

  Widget _buildStackCard(BuildContext context) {
    return ProjectCard(
      title: project.title,
      description: project.description,
      imageUrl: project.imageUrl,
      technologies: project.technologies,
      onTapGithub:
          project.githubUrl != null
              ? () => Helpers.launchURL(project.githubUrl!)
              : null,
      onTapLiveDemo:
          project.liveUrl != null
              ? () => Helpers.launchURL(project.liveUrl!)
              : null,
      animate: animate,
      animationKey: animationKey,
      width: width,
    );
  }

  Widget _buildGridCard(BuildContext context) {
    final isMobile = Helpers.isMobile(context);

    return StyledCard(
      useGlassEffect: true,
      width: width,
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(maxWidth: isMobile ? double.infinity : 320),
      animate: animate,
      animationKey: animationKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Project image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(DesignSystem.radiusLg),
              topRight: Radius.circular(DesignSystem.radiusLg),
            ),
            child: Image.network(
              project.imageUrl,
              height: isMobile ? 140 : 150,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: isMobile ? 140 : 150,
                  width: double.infinity,
                  color: Theme.of(context).colorScheme.primary.withAlpha(26),
                  child: const Center(child: Icon(Icons.image, size: 48)),
                );
              },
            ),
          ),

          // Project details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(DesignSystem.spacingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    project.title,
                    style: Theme.of(context).textTheme.titleLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: DesignSystem.spacingXs),

                  // Description with optimized display
                  Flexible(
                    child: Text(
                      project.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: isMobile ? 13 : 14,
                      ),
                      maxLines: isMobile ? 3 : 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  const SizedBox(height: DesignSystem.spacingSm),

                  // Technologies - limited to first 4 in grid view
                  Wrap(
                    spacing: DesignSystem.spacingXs,
                    runSpacing: DesignSystem.spacingXs,
                    children:
                        project.technologies.take(4).map((tech) {
                          return Chip(
                            label: Text(
                              tech,
                              style: TextStyle(
                                fontSize: 10,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            padding: EdgeInsets.zero,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                          );
                        }).toList(),
                  ),

                  const Spacer(),

                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (project.githubUrl != null)
                        _buildCompactActionButton(
                          context,
                          'GitHub',
                          Icons.code,
                          () => Helpers.launchURL(project.githubUrl!),
                        ),
                      if (project.githubUrl != null && project.liveUrl != null)
                        const SizedBox(width: DesignSystem.spacingSm),
                      if (project.liveUrl != null)
                        _buildCompactActionButton(
                          context,
                          'Live Demo',
                          Icons.open_in_new,
                          () => Helpers.launchURL(project.liveUrl!),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Compact action button for grid view
  Widget _buildCompactActionButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onTap,
  ) {
    return AnimationUtilities.createButtonPressAnimation(
      onPressed: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: DesignSystem.spacingXs,
          vertical: DesignSystem.spacingXxs,
        ),
        decoration: DesignSystem.getButtonDecoration(context),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            const SizedBox(width: DesignSystem.spacingXxs),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
