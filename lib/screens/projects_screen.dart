import 'package:flutter/material.dart';
import 'package:portfolio/models/project.dart';
import 'package:portfolio/utils/helpers.dart';
import 'package:portfolio/widgets/hover_effect.dart';
import 'package:portfolio/config/design_system.dart';
import 'package:portfolio/utils/image_cache_manager.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
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
              child: Text(
                'Projects',
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),

            SizedBox(height: DesignSystem.spacingSm),

            // Section subtitle
            Center(
              child: Text(
                'My recent work',
                style: Theme.of(context).textTheme.bodyLarge,
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
    return Center(
      child: Wrap(
        spacing: DesignSystem.spacingMd,
        runSpacing: DesignSystem.spacingMd,
        alignment: WrapAlignment.center,
        children:
            sampleProjects.map((project) {
              return _buildProjectCard(context, project);
            }).toList(),
      ),
    );
  }

  Widget _buildProjectCard(BuildContext context, Project project) {
    // Always use the remote URL for images to avoid asset loading issues
    final imageUrl = project.imageUrl;

    // Fixed width for the card
    final cardWidth =
        Helpers.isMobile(context)
            ? MediaQuery.of(context).size.width * 0.85
            : 350.0;

    return HoverEffect(
      scale: 1.02,
      elevationOnHover: DesignSystem.elevationMd,
      defaultElevation: DesignSystem.elevationSm,
      duration: DesignSystem.durationMedium,
      child: Card(
        elevation: 0, // Using HoverEffect for elevation
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignSystem.radiusLg),
        ),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          width: cardWidth,
          height: Helpers.isMobile(context) ? 450 : 500,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Project image - using optimized network image
              SizedBox(
                height: 200,
                width: double.infinity,
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
                        return Container(
                          color:
                              Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                          child: const Icon(Icons.image, size: 50),
                        );
                      },
                    ),

                    // Gradient overlay for better text visibility
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
                          maxLines: 5,
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

                      // Action buttons - centered for better layout
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (project.githubUrl != null) ...[
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
                              const SizedBox(width: DesignSystem.spacingMd),
                          ],
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
      ),
    );
  }
}
