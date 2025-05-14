import 'package:flutter/material.dart';
import 'package:portfolio/utils/helpers.dart';
import 'package:portfolio/widgets/animated_components.dart';
import 'package:portfolio/widgets/parallax_effect.dart';

/// A widget that displays floating skill tags around the profile image.
class FloatingSkillTags extends StatelessWidget {
  final bool isMobile;

  const FloatingSkillTags({super.key, this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    // Get the image size to determine the container size
    final imageSize = Helpers.isMobile(context) ? 280.0 : 320.0;

    // Create a container with a fixed size to hold the Stack
    return SizedBox(
      width: imageSize,
      height: imageSize,
      child: Stack(children: _buildFloatingSkillTags(context)),
    );
  }

  List<Widget> _buildFloatingSkillTags(BuildContext context) {
    // Reduce number of skill tags on mobile for better performance
    final skills =
        isMobile
            ? ['Flutter', 'Dart', 'Firebase']
            : ['Flutter', 'Dart', 'Firebase', 'UI/UX', 'Mobile'];

    // Get the center point based on image size
    final imageSize = Helpers.isMobile(context) ? 280.0 : 320.0;
    final centerX = imageSize / 2;
    final centerY = imageSize / 2;

    // Calculate positions relative to the center of the profile image
    // with better distribution and no overflow
    final positions =
        isMobile
            ? [
              Offset(centerX - 100, centerY - 100), // Top left
              Offset(centerX + 100, centerY - 100), // Top right
              Offset(centerX, centerY + 120), // Bottom center
            ]
            : [
              Offset(centerX - 160, centerY - 120), // Top left
              Offset(centerX + 160, centerY - 120), // Top right
              Offset(centerX + 180, centerY + 100), // Bottom right
              Offset(centerX - 180, centerY + 100), // Bottom left
              Offset(centerX, centerY + 180), // Bottom center
            ];

    // Use a fixed seed for deterministic randomness
    return List.generate(skills.length, (index) {
      // Apply parallax effect with different intensity for each tag
      final tagParallaxIntensity = 10.0 + (index * 5.0);

      return Positioned(
        left: positions[index].dx,
        top: positions[index].dy,
        child: ParallaxEffect(
          intensity: tagParallaxIntensity,
          enableScrollEffect: true,
          enableMouseTracking: !Helpers.isMobile(context),
          child: AnimatedSkillTag(
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
