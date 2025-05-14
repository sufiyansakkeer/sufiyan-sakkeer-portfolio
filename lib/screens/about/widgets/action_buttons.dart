import 'package:flutter/material.dart';
import 'package:portfolio/config/design_system.dart';
import 'package:portfolio/utils/constants.dart';
import 'package:portfolio/utils/helpers.dart';
import 'package:portfolio/widgets/hover_effect.dart';
import 'package:portfolio/widgets/page_reveal_transition.dart';
import 'package:portfolio/screens/home_screen.dart';

/// A widget that displays action buttons (Download Resume and Contact Me).
class ActionButtons extends StatelessWidget {
  final Duration duration;
  final Duration delay;
  final SlideDirection direction;

  const ActionButtons({
    super.key,
    this.duration = const Duration(milliseconds: 800),
    this.delay = const Duration(milliseconds: 1000),
    this.direction = SlideDirection.up,
  });

  @override
  Widget build(BuildContext context) {
    return SlideRevealTransition(
      duration: duration,
      delay: delay,
      direction: direction,
      child: Wrap(
        spacing: DesignSystem.spacingMd,
        runSpacing: DesignSystem.spacingMd,
        crossAxisAlignment:
            Helpers.isMobile(context)
                ? WrapCrossAlignment.center
                : WrapCrossAlignment.start,
        alignment:
            Helpers.isMobile(context)
                ? WrapAlignment.center
                : WrapAlignment.start,
        children: [
          // Download Resume button
          HoverEffect(
            scale: 1.05,
            enableElevation: true,
            child: ElevatedButton.icon(
              onPressed: () {
                // Launch the Google Drive resume link
                Helpers.launchURL(AppConstants.resumeUrl);
              },
              icon: const Icon(Icons.download),
              label: const Text('Download Resume'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal:
                      Helpers.isMobile(context)
                          ? DesignSystem.spacingSm
                          : DesignSystem.spacingMd,
                  vertical: DesignSystem.spacingSm,
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),

          // Contact Me button
          HoverEffect(
            scale: 1.05,
            enableElevation: true,
            child: OutlinedButton.icon(
              onPressed: () {
                // Find the parent HomeScreen and scroll to contact section
                final homeScreenState =
                    context.findAncestorStateOfType<HomeScreenState>();
                if (homeScreenState != null) {
                  homeScreenState.scrollToSection(
                    4,
                  ); // Contact section index
                }
              },
              icon: const Icon(Icons.email),
              label: const Text('Contact Me'),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal:
                      Helpers.isMobile(context)
                          ? DesignSystem.spacingSm
                          : DesignSystem.spacingMd,
                  vertical: DesignSystem.spacingSm,
                ),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
