import 'package:flutter/material.dart';
import 'package:portfolio/config/design_system.dart';
import 'package:portfolio/models/project.dart';
import 'package:portfolio/utils/animation_utilities.dart';
import 'package:portfolio/utils/helpers.dart';
import 'package:portfolio/widgets/projects/project_card_hero.dart';
import 'package:portfolio/widgets/projects/projects_toggle_button.dart';

/// A widget that displays projects in a stacked card layout
class ProjectsStackView extends StatelessWidget {
  final List<Project> projects;
  final VoidCallback onToggleView;
  final bool isTransitioning;

  const ProjectsStackView({
    super.key,
    required this.projects,
    required this.onToggleView,
    this.isTransitioning = false,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = Helpers.isMobile(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate card dimensions based on screen size
    final cardWidth = isMobile ? screenWidth * 0.85 : 400.0;

    // Create a stack with enhanced animations
    return MouseRegion(
      cursor:
          isTransitioning ? SystemMouseCursors.basic : SystemMouseCursors.click,
      child: GestureDetector(
        onTap:
            isTransitioning
                ? null
                : onToggleView, // Make the entire widget clickable only when not transitioning
        behavior:
            HitTestBehavior.opaque, // Ensures the entire area is clickable
        child: SizedBox(
          height: screenHeight * 0.7,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Stack of project cards with enhanced animations
              ...List.generate(projects.length, (index) {
                final project = projects[index];
                final isFirst = index == 0;

                // Calculate offset for stacked appearance with refined values
                final offset =
                    index *
                    18.0; // Slightly reduced spacing for more elegant stacking
                final scale =
                    1.0 -
                    (index *
                        0.025); // More subtle scaling for smoother appearance

                // Enhanced opacity calculation for better visual hierarchy
                final opacity =
                    1.0 - (index * 0.08); // More subtle opacity change
                final adjustedOpacity =
                    opacity < 0.9 ? 0.9 : opacity; // Higher minimum opacity

                // Use optimized animation durations for butter-smooth transitions
                final transitionDuration =
                    isTransitioning
                        ? const Duration(
                          milliseconds: 300,
                        ) // Slightly longer for smoother transition
                        : const Duration(
                          milliseconds: 400,
                        ); // Custom duration for optimal smoothness

                // Use optimized animation curves for ultra-smooth transitions
                final transitionCurve =
                    isTransitioning
                        ? Curves
                            .easeOutCubic // More pronounced ease out for grid-to-stack
                        : const Cubic(
                          0.2,
                          0.0,
                          0.2,
                          1.0,
                        ); // Custom curve for optimal smoothness

                return AnimatedPositioned(
                  duration: transitionDuration,
                  curve: transitionCurve,
                  top: offset,
                  child: IgnorePointer(
                    // Important: prevents cards from intercepting taps
                    child: AnimatedOpacity(
                      duration: transitionDuration,
                      curve: transitionCurve,
                      opacity: adjustedOpacity,
                      child: AnimatedScale(
                        duration: transitionDuration,
                        curve: transitionCurve,
                        scale: scale,
                        child: AnimationUtilities.createVisibilityTriggeredAnimation(
                          animationKey: 'project-card-$index',
                          duration: DesignSystem.durationMedium,
                          delay: Duration(milliseconds: index * 150),
                          slideOffset: const Offset(0, 0.1),
                          curve: DesignSystem.curveSmooth,
                          rotateAngle:
                              index.isEven
                                  ? 0.01
                                  : -0.01, // Add a small rotation for 3D effect
                          child: ProjectCardHero(
                            project: project,
                            heroTag: 'project-${project.title}',
                            width: cardWidth,
                            isActive: isFirst,
                            animate: false, // Animation is handled by the stack
                            onTap:
                                isFirst
                                    ? onToggleView
                                    : null, // Only make the top card clickable
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),

              // Add toggle button
              ProjectsToggleButton(
                isGridView: false,
                onToggle: onToggleView,
                isTransitioning: isTransitioning,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
