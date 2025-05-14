import 'package:flutter/material.dart';
import 'package:portfolio/config/design_system.dart';
import 'package:portfolio/models/project.dart';
import 'package:portfolio/widgets/projects/projects_grid_view.dart';
import 'package:portfolio/widgets/projects/projects_stack_view.dart';
import 'package:portfolio/widgets/section_header.dart';

/// The main view widget for the Projects screen
class ProjectsScreenView extends StatelessWidget {
  final List<Project> projects;
  final bool isGridView;
  final bool isTransitioning;
  final bool isTransitioningToGrid;
  final VoidCallback onToggleView;
  final ScrollController scrollController;

  const ProjectsScreenView({
    super.key,
    required this.projects,
    required this.isGridView,
    required this.isTransitioning,
    required this.isTransitioningToGrid,
    required this.onToggleView,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      animationKey: 'projects-section',
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header with consistent styling
            SectionHeader(
              title: 'Projects',
              subtitle: 'My recent work',
              animationKey: 'projects',
            ),

            const SizedBox(height: DesignSystem.spacingLg),

            // Projects layout with enhanced smooth transition between views
            LayoutBuilder(
              builder: (context, constraints) {
                // Enhanced transition with custom animation controller
                return AnimatedSwitcher(
                  // Use optimized durations for butter-smooth transitions
                  duration:
                      isGridView
                          ? const Duration(
                            milliseconds: 350,
                          ) // Slightly longer for smoother fade-out
                          : const Duration(
                            milliseconds: 650,
                          ), // Custom duration for optimal smoothness
                  // Use optimized curves for ultra-smooth transitions
                  switchInCurve:
                      isGridView
                          ? const Cubic(
                            0.33,
                            1.0,
                            0.68,
                            1.0,
                          ) // Custom curve for smoother entrance
                          : const Cubic(
                            0.22,
                            1.0,
                            0.36,
                            1.0,
                          ), // Custom curve for optimal smoothness
                  switchOutCurve:
                      isGridView
                          ? const Cubic(
                            0.32,
                            0.0,
                            0.67,
                            0.0,
                          ) // Custom curve for smoother exit
                          : const Cubic(
                            0.25,
                            0.0,
                            0.30,
                            1.0,
                          ), // Custom curve for optimal smoothness
                  // Custom transition builder with combined animations
                  transitionBuilder: (
                    Widget child,
                    Animation<double> animation,
                  ) {
                    // We'll create specialized curved animations for each transition case

                    // Get the key to determine which view we're transitioning to
                    final isGridView =
                        child.key == const ValueKey<String>('grid-view');
                    final isStackView =
                        child.key == const ValueKey<String>('stack-view');

                    // Special handling for grid-to-stack transition with ultra-smooth animations
                    if (isStackView &&
                        isTransitioning &&
                        !isTransitioningToGrid) {
                      // Use a custom transition for grid-to-stack with optimized animation
                      final specialCurvedAnimation = CurvedAnimation(
                        parent: animation,
                        curve: const Cubic(
                          0.2,
                          0.0,
                          0.0,
                          1.0,
                        ), // Custom curve for butter-smooth transition
                        reverseCurve: const Cubic(0.4, 0.0, 0.2, 1.0),
                      );

                      // Create a sequence of micro-animations for a more polished effect
                      final fadeAnimation = TweenSequence<double>([
                        TweenSequenceItem(
                          tween: Tween<double>(
                            begin: 0.0,
                            end: 0.6,
                          ).chain(CurveTween(curve: Curves.easeOut)),
                          weight: 30,
                        ),
                        TweenSequenceItem(
                          tween: Tween<double>(
                            begin: 0.6,
                            end: 1.0,
                          ).chain(CurveTween(curve: Curves.easeOutCubic)),
                          weight: 70,
                        ),
                      ]).animate(specialCurvedAnimation);

                      return FadeTransition(
                        opacity: fadeAnimation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(
                              0.0,
                              0.03,
                            ), // Reduced offset for subtler motion
                            end: Offset.zero,
                          ).animate(specialCurvedAnimation),
                          child: ScaleTransition(
                            scale: Tween<double>(
                              begin:
                                  0.985, // Subtler scale for smoother transition
                              end: 1.0,
                            ).animate(specialCurvedAnimation),
                            child: child,
                          ),
                        ),
                      );
                    }

                    // Special handling for stack-to-grid transition with enhanced animations
                    if (isGridView &&
                        isTransitioning &&
                        isTransitioningToGrid) {
                      // Use a custom transition for stack-to-grid with ultra-smooth animation
                      final gridCurvedAnimation = CurvedAnimation(
                        parent: animation,
                        curve: const Cubic(
                          0.25,
                          0.1,
                          0.0,
                          1.0,
                        ), // Custom curve for butter-smooth transition
                        reverseCurve: const Cubic(0.3, 0.0, 0.1, 1.0),
                      );

                      // Create a staggered fade effect for a more polished transition
                      final gridFadeAnimation = TweenSequence<double>([
                        TweenSequenceItem(
                          tween: Tween<double>(
                            begin: 0.0,
                            end: 0.4,
                          ).chain(CurveTween(curve: Curves.easeIn)),
                          weight: 20,
                        ),
                        TweenSequenceItem(
                          tween: Tween<double>(
                            begin: 0.4,
                            end: 1.0,
                          ).chain(CurveTween(curve: Curves.easeOutCubic)),
                          weight: 80,
                        ),
                      ]).animate(gridCurvedAnimation);

                      return FadeTransition(
                        opacity: gridFadeAnimation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(
                              0.0,
                              -0.02,
                            ), // Subtler motion for smoother transition
                            end: Offset.zero,
                          ).animate(gridCurvedAnimation),
                          child: ScaleTransition(
                            scale: Tween<double>(
                              begin:
                                  0.99, // Very subtle scale for smoother transition
                              end: 1.0,
                            ).animate(gridCurvedAnimation),
                            child: child,
                          ),
                        ),
                      );
                    }

                    // Default transition with enhanced combined effects for butter-smooth animations
                    // Create a custom curved animation for smoother default transitions
                    final defaultCurvedAnimation = CurvedAnimation(
                      parent: animation,
                      curve: const Cubic(
                        0.2,
                        0.0,
                        0.0,
                        1.0,
                      ), // Custom curve for optimal smoothness
                      reverseCurve: const Cubic(0.4, 0.0, 0.2, 1.0),
                    );

                    // Use subtler offsets and scales for more refined motion
                    return FadeTransition(
                      opacity: defaultCurvedAnimation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin:
                              isGridView
                                  ? const Offset(
                                    0.0,
                                    -0.02,
                                  ) // Reduced offset for subtler motion
                                  : const Offset(0.0, 0.02),
                          end: Offset.zero,
                        ).animate(defaultCurvedAnimation),
                        child: ScaleTransition(
                          scale: Tween<double>(
                            begin:
                                0.99, // Very subtle scale for smoother transition
                            end: 1.0,
                          ).animate(defaultCurvedAnimation),
                          child: child,
                        ),
                      ),
                    );
                  },
                  // Use layout builder to maintain consistent size during transition
                  layoutBuilder: (
                    Widget? currentChild,
                    List<Widget> previousChildren,
                  ) {
                    return Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        ...previousChildren,
                        if (currentChild != null) currentChild,
                      ],
                    );
                  },
                  child:
                      isGridView
                          ? KeyedSubtree(
                            key: const ValueKey<String>('grid-view'),
                            child: ProjectsGridView(
                              projects: projects,
                              onToggleView: onToggleView,
                              isTransitioning: isTransitioning,
                              isTransitioningToGrid: isTransitioningToGrid,
                            ),
                          )
                          : KeyedSubtree(
                            key: const ValueKey<String>('stack-view'),
                            child: ProjectsStackView(
                              projects: projects,
                              onToggleView: onToggleView,
                              isTransitioning: isTransitioning,
                            ),
                          ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
