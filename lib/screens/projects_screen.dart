import 'package:flutter/material.dart';
import 'package:portfolio/models/project.dart';
import 'package:portfolio/utils/helpers.dart';
import 'package:portfolio/widgets/hover_effect.dart';
import 'package:portfolio/config/design_system.dart';

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
    final crossAxisCount =
        Helpers.isMobile(context)
            ? 1
            : Helpers.isTablet(context)
            ? 2
            : 3;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
        childAspectRatio: 0.75,
      ),
      itemCount: sampleProjects.length,
      itemBuilder: (context, index) {
        return _buildProjectCard(context, sampleProjects[index]);
      },
    );
  }

  Widget _buildProjectCard(BuildContext context, Project project) {
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
            // Project image
            Expanded(
              flex: 5,
              child: Container(
                width: double.infinity,
                color: Colors.grey.shade300,
                child: Center(
                  child: Icon(
                    Icons.code,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),

            // Project details
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.all(DesignSystem.spacingSm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Project title
                    Text(
                      project.title,
                      style: Theme.of(context).textTheme.headlineMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: DesignSystem.spacingXs),

                    // Project description
                    Expanded(
                      child: Text(
                        project.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 4,
                      ),
                    ),

                    const SizedBox(height: DesignSystem.spacingXs),

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

                    const SizedBox(height: DesignSystem.spacingSm),

                    // Action buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (project.githubUrl != null)
                          HoverEffect(
                            enableElevation: false,
                            scale: 1.1,
                            duration: DesignSystem.durationFast,
                            child: IconButton(
                              icon: const Icon(Icons.code),
                              onPressed: () {
                                Helpers.launchURL(project.githubUrl!);
                              },
                              tooltip: 'View Code',
                            ),
                          ),
                        if (project.liveUrl != null)
                          HoverButton(
                            onPressed: () {
                              Helpers.launchURL(project.liveUrl!);
                            },
                            padding: const EdgeInsets.symmetric(
                              horizontal: DesignSystem.spacingSm,
                              vertical: DesignSystem.spacingXs,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.launch, size: 16),
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
