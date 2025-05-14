import 'package:flutter/material.dart';
import 'dart:math' show min;
import 'package:portfolio/config/design_system.dart';
import 'package:portfolio/models/project.dart';
import 'package:portfolio/utils/animation_utilities.dart';
import 'package:portfolio/utils/helpers.dart';
import 'package:portfolio/widgets/projects/project_card_hero.dart';
import 'package:portfolio/widgets/projects/projects_toggle_button.dart';

/// A widget that displays projects in a grid layout
class ProjectsGridView extends StatelessWidget {
  final List<Project> projects;
  final VoidCallback onToggleView;
  final bool isTransitioning;
  final bool isTransitioningToGrid;

  const ProjectsGridView({
    super.key,
    required this.projects,
    required this.onToggleView,
    this.isTransitioning = false,
    this.isTransitioningToGrid = false,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = Helpers.isMobile(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate card dimensions and grid properties based on screen size
    final cardWidth = isMobile ? screenWidth * 0.85 : 320.0;

    // Adjust cross axis count based on screen width for responsive layout
    final crossAxisCount = isMobile ? 1 : (screenWidth < 1100 ? 2 : 3);

    return Stack(
      children: [
        // Grid view of projects with enhanced animations
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal:
                isMobile ? DesignSystem.spacingSm : DesignSystem.spacingMd,
            vertical: DesignSystem.spacingMd,
          ),
          child: Column(
            children: [
              // Toggle button at the top
              ProjectsToggleButton(
                isGridView: true,
                onToggle: onToggleView,
                isTransitioning: isTransitioning,
              ),

              // Grid of projects with enhanced animations
              Container(
                constraints: BoxConstraints(
                  minHeight:
                      isMobile
                          ? min(screenHeight * 0.5, screenHeight * 0.75)
                          : min(screenHeight * 0.4, screenHeight * 0.75),
                ),
                // Use LayoutBuilder to get exact available constraints
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Calculate appropriate card height based on available height
                    final availableHeight = constraints.maxHeight;
                    final adjustedCardHeight =
                        isMobile
                            ? min(480.0, availableHeight * 0.9)
                            : min(500.0, availableHeight * 0.45);

                    return GridView.builder(
                      shrinkWrap: true,
                      primary: false,
                      physics: const ClampingScrollPhysics(),
                      padding: EdgeInsets.only(
                        top: isMobile ? DesignSystem.spacingMd : 0,
                        bottom: DesignSystem.spacingLg,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio:
                            isMobile
                                ? 0.65
                                : cardWidth / (adjustedCardHeight * 0.85),
                        crossAxisSpacing: DesignSystem.spacingMd,
                        mainAxisSpacing: DesignSystem.spacingLg,
                      ),
                      itemCount: projects.length,
                      itemBuilder: (context, index) {
                        final project = projects[index];

                        // Calculate staggered delay for smoother appearance
                        final staggerDelay = Duration(
                          milliseconds: 50 + (index * 60),
                        );

                        // Enhanced animation for grid items with staggered effect
                        return AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut,
                          opacity:
                              isTransitioning && !isTransitioningToGrid
                                  ? 0.0
                                  : 1.0,
                          child: AnimationUtilities.createVisibilityTriggeredAnimation(
                            animationKey: 'project-grid-card-$index',
                            duration: DesignSystem.durationSlow,
                            delay: staggerDelay,
                            slideOffset: const Offset(0, 0.05),
                            scaleStart: 0.98,
                            curve: DesignSystem.curveSmooth,
                            child: ProjectCardHero(
                              project: project,
                              heroTag: 'project-${project.title}',
                              width: cardWidth,
                              isGridView: true,
                              isActive: true,
                              animate:
                                  false, // Animation is handled by the parent
                              onTap:
                                  isTransitioning
                                      ? null
                                      : () =>
                                          onToggleView(), // Make each grid card clickable to go back to stack when not transitioning
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
