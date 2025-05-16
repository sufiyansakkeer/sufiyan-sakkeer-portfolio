import 'package:flutter/material.dart';
import 'package:portfolio/models/project.dart';
import 'package:portfolio/config/design_system.dart';
import 'package:portfolio/widgets/projects/projects_screen_view.dart';

/// The main Projects screen widget that manages state and transitions
/// between stack and grid views
class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  bool _isGridView = false;

  // Animation controller for smoother transitions
  late AnimationController _viewTransitionController;

  // Flag to track if we're currently transitioning between views
  bool _isTransitioning = false;

  // Flag to track the direction of transition (for specialized animations)
  bool _isTransitioningToGrid = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // Initialize the transition animation controller
    _viewTransitionController = AnimationController(
      vsync: this,
      duration: DesignSystem.durationSlow,
    );

    // Listen to animation completion to update state
    _viewTransitionController.addStatusListener(_handleAnimationStatus);
  }

  @override
  void dispose() {
    _viewTransitionController.removeStatusListener(_handleAnimationStatus);
    _viewTransitionController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Handle animation status changes
  void _handleAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      setState(() {
        _isTransitioning = false;
      });
    }
  }

  // Toggle between stacked and grid view with smoother transition
  void _toggleViewMode() {
    // If already transitioning, don't allow another toggle
    if (_isTransitioning) return;

    // Set transition flags
    setState(() {
      _isTransitioning = true;
      _isTransitioningToGrid = !_isGridView;
    });

    if (_isGridView) {
      // Transitioning from grid to stack
      // First, allow time for grid items to fade out
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          // Then change the view mode
          setState(() {
            _isGridView = false;
          });

          // Allow time for stack items to animate in before ending transition state
          Future.delayed(DesignSystem.durationSlow, () {
            if (mounted) {
              setState(() {
                _isTransitioning = false;
              });
            }
          });
        }
      });
    } else {
      // Transitioning from stack to grid
      // For stack to grid, we change state immediately
      setState(() {
        _isGridView = true;
      });

      // Reset transition state after animation completes
      Future.delayed(DesignSystem.durationSlow, () {
        if (mounted) {
          setState(() {
            _isTransitioning = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProjectsScreenView(
      projects: sampleProjects,
      isGridView: _isGridView,
      isTransitioning: _isTransitioning,
      isTransitioningToGrid: _isTransitioningToGrid,
      onToggleView: _toggleViewMode,
      scrollController: _scrollController,
    );
  }
}
