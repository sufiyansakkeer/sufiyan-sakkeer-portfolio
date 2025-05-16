import 'package:flutter/material.dart';
import 'package:portfolio/config/design_system.dart';
import 'package:portfolio/utils/animation_utilities.dart';

/// A toggle button widget for switching between stack and grid views
class ProjectsToggleButton extends StatelessWidget {
  final bool isGridView;
  final VoidCallback onToggle;
  final bool isTransitioning;

  const ProjectsToggleButton({
    super.key,
    required this.isGridView,
    required this.onToggle,
    this.isTransitioning = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isGridView) {
      return _buildGridToStackButton(context);
    } else {
      return _buildStackToGridButton(context);
    }
  }

  Widget _buildStackToGridButton(BuildContext context) {
    return Positioned(
      bottom: 20,
      child: AnimatedOpacity(
        duration: DesignSystem.durationMedium,
        opacity: isTransitioning ? 0.0 : 1.0, // Hide during transition
        child: Text(
          'tap to expand',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildGridToStackButton(BuildContext context) {
    return AnimatedOpacity(
      duration: DesignSystem.durationMedium,
      opacity: isTransitioning && isGridView ? 0.0 : 1.0,
      child: Align(
        alignment: Alignment.centerRight,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            // onTap: onToggle,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: DesignSystem.spacingMd,
                right: DesignSystem.spacingSm,
              ),
              child: AnimationUtilities.createButtonPressAnimation(
                onPressed: onToggle,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon(
                    //   Icons.layers,
                    //   size: 14,
                    //   color: Theme.of(context).colorScheme.primary,
                    // ),
                    // const SizedBox(width: DesignSystem.spacingXs),
                    // Text(
                    //   'back to stack view',
                    //   style: TextStyle(
                    //     color: Theme.of(context).colorScheme.primary,
                    //     fontSize: 12,
                    //     fontWeight: FontWeight.w500,
                    //     letterSpacing: 1.2,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
