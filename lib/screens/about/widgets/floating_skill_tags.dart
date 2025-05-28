import 'package:flutter/material.dart';
import 'package:portfolio/utils/helpers.dart';
import 'package:portfolio/widgets/animated_components.dart';
import 'package:portfolio/widgets/parallax_effect.dart';

/// A widget that displays floating skill tags around the profile image.
class FloatingSkillTags extends StatefulWidget {
  final bool isMobile;

  const FloatingSkillTags({super.key, this.isMobile = false});

  @override
  State<FloatingSkillTags> createState() => _FloatingSkillTagsState();
}

class _FloatingSkillTagsState extends State<FloatingSkillTags>
    with TickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 8),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the image size to determine the container size
    final imageSize = Helpers.isMobile(context) ? 280.0 : 320.0;

    // Create a container with a larger size to ensure tags don't get cropped
    // Add extra padding around the image size to accommodate the tags
    final containerSize = imageSize * 1.5;

    // Create a container with a fixed size to hold the Stack
    return SizedBox(
      width: containerSize,
      height: containerSize,
      child: Stack(
        clipBehavior: Clip.none, // Ensure no clipping occurs
        alignment: Alignment.center, // Center the stack contents
        children: _buildFloatingSkillTags(context, _animationController),
      ),
    );
  }

  List<Widget> _buildFloatingSkillTags(
    BuildContext context,
    AnimationController animationController,
  ) {
    // Reduce number of skill tags on mobile for better performance
    final skills =
        widget.isMobile
            ? ['Flutter', 'Dart', 'Firebase']
            : ['Flutter', 'Dart', 'Firebase', 'UI/UX', 'Mobile'];

    // Get the center point based on image size
    final imageSize = Helpers.isMobile(context) ? 280.0 : 320.0;
    final centerX = imageSize / 2;
    final centerY = imageSize / 2;

    // Calculate positions relative to the center of the profile image
    // with better distribution and no overflow
    // Adjust positions to ensure tags are fully visible
    final positions =
        widget.isMobile
            ? [
              Offset(centerX - 90, centerY - 90), // Top left - moved inward
              Offset(centerX + 90, centerY - 90), // Top right - moved inward
              Offset(centerX, centerY + 110), // Bottom center - moved inward
            ]
            : [
              Offset(centerX - 140, centerY - 110), // Top left - moved inward
              Offset(centerX + 140, centerY - 110), // Top right - moved inward
              Offset(
                centerX + 160,
                centerY + 90,
              ), // Bottom right - moved inward
              Offset(centerX - 160, centerY + 90), // Bottom left - moved inward
              Offset(centerX, centerY + 160), // Bottom center - moved inward
            ];

    // Use a fixed seed for deterministic randomness
    return List.generate(skills.length, (index) {
      // Apply parallax effect with reduced intensity to prevent overflow
      // Reduce the intensity to ensure tags don't move too far
      final tagParallaxIntensity = 5.0 + (index * 2.0);

      return Positioned(
        left: positions[index].dx,
        top: positions[index].dy,
        child: ParallaxEffect(
          intensity: tagParallaxIntensity,
          enableScrollEffect: true,
          enableMouseTracking: !Helpers.isMobile(context),
          child: AnimatedSkillTag(
            animationController: animationController,
            skill: skills[index],
            color: _getColorForIndex(index, context),
            // Increase delay between animations for better performance
            delay: Duration(milliseconds: 500 * index),
          ),
        ),
      );
    });
  }

  Color _getColorForIndex(int index, BuildContext context) {
    final colors = [
      Theme.of(context).colorScheme.primary.withAlpha(40),
      Theme.of(context).colorScheme.secondary.withAlpha(30),
      Theme.of(context).colorScheme.tertiary.withAlpha(25),
      Theme.of(context).colorScheme.primary.withAlpha(20),
      Theme.of(context).colorScheme.secondary.withAlpha(15),
    ];

    return colors[index % colors.length];
  }
}
