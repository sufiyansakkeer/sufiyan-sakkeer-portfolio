import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:portfolio/utils/helpers.dart';
import 'package:portfolio/widgets/animated_components.dart';
import 'package:portfolio/widgets/page_reveal_transition.dart';

/// A widget that displays the profile image with animations and effects.
class ProfileImage extends StatelessWidget {
  const ProfileImage({super.key});

  @override
  Widget build(BuildContext context) {
    final imageSize = Helpers.isMobile(context) ? 280.0 : 320.0;

    return Center(
      child: RepaintBoundary(
        // Add RepaintBoundary to isolate repainting
        child: Container(
          width: imageSize,
          height: imageSize,
          constraints: BoxConstraints(
            maxWidth: imageSize,
            maxHeight: imageSize,
          ),
          child: SlideRevealTransition(
            duration: const Duration(milliseconds: 1000),
            delay: const Duration(milliseconds: 300),
            direction: SlideDirection.left,
            child: Stack(
              children: [
                // Glowing background
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary.withAlpha(80),
                        Theme.of(context).colorScheme.primary.withAlpha(30),
                      ],
                      stops: const [0.5, 1.0],
                    ),
                    // Simpler shadow for better performance
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withAlpha(40),
                        blurRadius: 20,
                        spreadRadius: 0,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),

                // Only show rotating border on desktop for better performance
                if (!Helpers.isMobile(context))
                  RotatingBorder(
                    color: Theme.of(context).colorScheme.primary.withAlpha(100),
                    width: 2,
                  ),

                // Profile image
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipOval(
                    child: SvgPicture.asset(
                      'assets/svg/profile_pic.svg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
