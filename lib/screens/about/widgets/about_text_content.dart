import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:portfolio/config/design_system.dart';
import 'package:portfolio/utils/constants.dart';
import 'package:portfolio/utils/helpers.dart';
import 'package:portfolio/widgets/animated_components.dart';
import 'package:portfolio/widgets/animated_text_reveal.dart';
import 'package:portfolio/widgets/page_reveal_transition.dart';
import 'package:portfolio/widgets/social_bar.dart';
import 'package:portfolio/screens/about/widgets/highlighted_text.dart';
import 'package:portfolio/screens/about/widgets/stats_section.dart';
import 'package:portfolio/screens/about/widgets/action_buttons.dart';

/// A widget that displays the text content section of the About screen.
class AboutTextContent extends StatelessWidget {
  const AboutTextContent({super.key});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      // Add RepaintBoundary to isolate repainting
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Greeting with animated gradient text - only on desktop for better performance
          if (!Helpers.isMobile(context))
            AnimatedGradientText(
              text: 'Hello, I\'m',
              style: Theme.of(context).textTheme.headlineMedium!,
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
              ],
              duration: const Duration(
                milliseconds: 4000,
              ), // Slower animation for better performance
            )
          else
            Text(
              'Hello, I\'m',
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),

          const SizedBox(height: DesignSystem.spacingSm),

          // Name with animated text reveal
          AnimatedTextReveal(
            text: AppConstants.name,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
            duration: const Duration(milliseconds: 800),
            delay: const Duration(milliseconds: 400),
            animationType: StaggeredTextAnimation.fadeSlideUp,
          ),

          const SizedBox(height: DesignSystem.spacingSm),

          // Multiple titles with rotating effect
          SizedBox(
            height: 40, // Fixed height to prevent layout shifts
            child: AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  AppConstants.title,
                  textStyle: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                  speed: const Duration(milliseconds: 100),
                ),
                TypewriterAnimatedText(
                  'Freelancer',
                  textStyle: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                  speed: const Duration(milliseconds: 100),
                ),
                TypewriterAnimatedText(
                  'Mobile App Enthusiast',
                  textStyle: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                  speed: const Duration(milliseconds: 100),
                ),
                TypewriterAnimatedText(
                  'Open Source Contributor',
                  textStyle: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                  speed: const Duration(milliseconds: 100),
                ),
              ],
              repeatForever: true,
              pause: const Duration(
                seconds: 2,
              ), // 4 seconds pause between titles
              displayFullTextOnTap: true,
              isRepeatingAnimation: true,
            ),
          ),

          const SizedBox(height: DesignSystem.spacingMd),

          // About me text with highlight spans
          HighlightedText(
            text: AppConstants.aboutMe,
            highlightTerms: [
              'Flutter',
              'mobile applications',
              'responsive',
              'user-friendly',
            ],
          ),

          const SizedBox(height: DesignSystem.spacingLg),

          // Stats section
          const StatsSection(),

          const SizedBox(height: DesignSystem.spacingLg),

          // Action buttons
          const ActionButtons(),

          const SizedBox(height: DesignSystem.spacingLg),

          // Social bar with enhanced styling
          SlideRevealTransition(
            duration: const Duration(milliseconds: 800),
            delay: const Duration(milliseconds: 1200),
            direction: SlideDirection.up,
            child: const SocialBar(),
          ),
        ],
      ),
    );
  }
}
