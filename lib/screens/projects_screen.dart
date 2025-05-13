import 'package:flutter/material.dart';
import 'package:portfolio/models/project.dart';
import 'package:portfolio/utils/helpers.dart';
import 'package:portfolio/widgets/hover_effect.dart';
import 'package:portfolio/config/design_system.dart';
import 'package:portfolio/widgets/animated_text_reveal.dart';
import 'package:portfolio/widgets/page_reveal_transition.dart';
import 'package:portfolio/utils/image_cache_manager.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildContent(context);
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: DesignSystem.getSectionPadding(context),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section title
            Center(
              child: AnimatedTextReveal(
                text: 'Projects',
                style: Theme.of(context).textTheme.displayMedium,
                duration: const Duration(milliseconds: 800),
                delay: const Duration(milliseconds: 200),
                animationType: StaggeredTextAnimation.fadeSlideUp,
              ),
            ),

            SizedBox(height: DesignSystem.spacingSm),

            // Section subtitle
            Center(
              child: AnimatedTextReveal(
                text: 'My recent work',
                style: Theme.of(context).textTheme.bodyLarge,
                duration: const Duration(milliseconds: 800),
                delay: const Duration(milliseconds: 400),
                animationType: StaggeredTextAnimation.fadeIn,
              ),
            ),

            SizedBox(height: DesignSystem.spacingXl),

            // Projects grid
            _buildProjectsGrid(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectsGrid(BuildContext context) {
    final crossAxisCount =
        Helpers.isMobile(context)
            ? 1
            : Helpers.isTablet(context)
            ? 2
            : 3;

    // Adjust aspect ratio based on screen size for better visual balance
    final childAspectRatio = Helpers.isMobile(context) ? 0.8 : 0.75;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: DesignSystem.spacingMd,
        mainAxisSpacing: DesignSystem.spacingLg,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: sampleProjects.length,
      itemBuilder: (context, index) {
        // Add staggered animation to each card
        return SlideRevealTransition(
          duration: const Duration(milliseconds: 800),
          delay: Duration(milliseconds: 600 + (index * 200)),
          direction: SlideDirection.up,
          child: _buildProjectCard(context, sampleProjects[index], index),
        );
      },
    );
  }

  Widget _buildProjectCard(BuildContext context, Project project, int index) {
    // Always use the remote URL for images to avoid asset loading issues
    final imageUrl = project.imageUrl;

    return HoverEffect(
      scale: 1.03,
      elevationOnHover: DesignSystem.elevationMd,
      defaultElevation: DesignSystem.elevationSm,
      duration: DesignSystem.durationMedium,
      child: Card(
        elevation: 0, // We're using the HoverEffect for elevation
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignSystem.radiusLg),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project image - using optimized network image
            Expanded(
              flex: 5,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Optimized image with caching and error handling
                  OptimizedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    placeholderColor:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    fadeInDuration: const Duration(milliseconds: 300),
                    errorWidget: (context, url, error) {
                      // Fallback to a placeholder if there's an issue with the image
                      return Image.network(
                        'https://picsum.photos/id/${1000 + index}/800/600',
                        fit: BoxFit.cover,
                      );
                    },
                  ),

                  // Gradient overlay for better text visibility if needed
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withAlpha(178), // 0.7 opacity
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Project title overlay on the image
                  Positioned(
                    bottom: DesignSystem.spacingSm,
                    left: DesignSystem.spacingSm,
                    right: DesignSystem.spacingSm,
                    child: Text(
                      project.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 3.0,
                            color: Colors.black.withAlpha(128), // 0.5 opacity
                            offset: const Offset(1.0, 1.0),
                          ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // Project details
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.all(DesignSystem.spacingMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Project description
                    Expanded(
                      child: Text(
                        project.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 4,
                      ),
                    ),

                    const SizedBox(height: DesignSystem.spacingSm),

                    // Technologies used
                    Wrap(
                      spacing: DesignSystem.spacingXs,
                      runSpacing: DesignSystem.spacingXs,
                      children:
                          project.technologies.map((tech) {
                            return Chip(
                              label: Text(
                                tech,
                                style: const TextStyle(fontSize: 12),
                              ),
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primary.withAlpha(26),
                              padding: EdgeInsets.zero,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            );
                          }).toList(),
                    ),

                    const SizedBox(height: DesignSystem.spacingMd),

                    // Action buttons - improved layout and visibility
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (project.githubUrl != null)
                          HoverButton(
                            onPressed: () {
                              Helpers.launchURL(project.githubUrl!);
                            },
                            backgroundColor:
                                Theme.of(
                                  context,
                                ).colorScheme.secondaryContainer,
                            padding: const EdgeInsets.symmetric(
                              horizontal: DesignSystem.spacingSm,
                              vertical: DesignSystem.spacingXs,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.code, size: 18),
                                const SizedBox(width: DesignSystem.spacingXs),
                                const Text('GitHub'),
                              ],
                            ),
                          ),
                        if (project.liveUrl != null)
                          HoverButton(
                            onPressed: () {
                              Helpers.launchURL(project.liveUrl!);
                            },
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: DesignSystem.spacingSm,
                              vertical: DesignSystem.spacingXs,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.launch, size: 18),
                                const SizedBox(width: DesignSystem.spacingXs),
                                const Text('Live Demo'),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
