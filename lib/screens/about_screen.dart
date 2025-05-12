import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:portfolio/utils/constants.dart';
import 'package:portfolio/utils/helpers.dart';
import 'package:portfolio/widgets/social_bar.dart';
import 'package:portfolio/screens/home_screen.dart';
import 'package:portfolio/widgets/animated_text_reveal.dart';
import 'package:portfolio/widgets/parallax_effect.dart';
import 'package:portfolio/config/design_system.dart';
import 'package:portfolio/widgets/page_reveal_transition.dart';
import 'package:portfolio/widgets/hover_effect.dart';
import 'package:portfolio/widgets/animated_components.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildContent(context);
  }

  Widget _buildContent(BuildContext context) {
    return Stack(
      children: [
        // Animated background elements
        _buildAnimatedBackground(context),

        // Main content
        SingleChildScrollView(
          child: Padding(
            padding: DesignSystem.getCardPadding(context),
            child:
                Helpers.isMobile(context)
                    ? _buildMobileLayout(context)
                    : _buildDesktopLayout(context),
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedBackground(BuildContext context) {
    return Positioned.fill(
      child: RepaintBoundary(
        // Add RepaintBoundary to isolate repainting
        child: Stack(
          children: [
            // Gradient background
            Positioned.fill(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.surface,
                      Theme.of(context).colorScheme.primary.withAlpha(15),
                    ],
                  ),
                ),
              ),
            ),

            // Animated circles - reduced to 3 for better performance
            ...List.generate(3, (index) {
              final size = 120.0 + (index * 60.0);
              final position = _getRandomPosition(index, context);
              final color = _getColorForIndex(index, context);

              return Positioned(
                left: position.dx,
                top: position.dy,
                child: AnimatedBlurredCircle(
                  size: size,
                  color: color,
                  // Slower animations for better performance
                  duration: Duration(milliseconds: 12000 + (index * 3000)),
                ),
              );
            }),

            // Mesh overlay - only show on desktop for better performance
            if (!Helpers.isMobile(context))
              Positioned.fill(
                child: CustomPaint(
                  painter: MeshPainter(
                    lineColor: Theme.of(
                      context,
                    ).colorScheme.primary.withAlpha(10),
                    lineWidth: 0.5,
                    gridSize: 60, // Increased grid size for better performance
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Offset _getRandomPosition(int index, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Create deterministic but seemingly random positions
    final positions = [
      Offset(-50, screenHeight * 0.2),
      Offset(screenWidth * 0.8, -80),
      Offset(screenWidth * 0.1, screenHeight * 0.8),
      Offset(screenWidth * 0.7, screenHeight * 0.7),
      Offset(screenWidth * 0.5, screenHeight * 0.3),
    ];

    return positions[index % positions.length];
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

  Widget _buildDesktopLayout(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height - 100,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left side - Profile image and decorative elements
          Expanded(
            flex: 5,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                // Background decorative elements
                Positioned(
                  left: -50,
                  top: 50,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(
                        context,
                      ).colorScheme.secondary.withAlpha(15),
                    ),
                  ),
                ),

                // Profile image with effects
                _buildProfileImage(context),

                // Skill tags floating around
                ..._buildFloatingSkillTags(context),
              ],
            ),
          ),

          // Right side - Text content in glass card
          Expanded(
            flex: 7,
            child: _buildGlassCard(context, child: _buildTextContent(context)),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height - 100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile image with floating skill tags
          SizedBox(
            height: 350,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                _buildProfileImage(context),
                ..._buildFloatingSkillTags(context, isMobile: true),
              ],
            ),
          ),

          const SizedBox(height: DesignSystem.spacingLg),

          // Text content in glass card
          _buildGlassCard(context, child: _buildTextContent(context)),
        ],
      ),
    );
  }

  List<Widget> _buildFloatingSkillTags(
    BuildContext context, {
    bool isMobile = false,
  }) {
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

  Widget _buildGlassCard(BuildContext context, {required Widget child}) {
    // On mobile, use a simpler card without backdrop filter for better performance
    if (Helpers.isMobile(context)) {
      return Container(
        padding: DesignSystem.getCardPadding(context),
        decoration: BoxDecoration(
          color: Theme.of(
            context,
          ).colorScheme.surface.withAlpha(230), // More opaque for mobile
          borderRadius: BorderRadius.circular(DesignSystem.radiusLg),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withAlpha(50),
            width: 1,
          ),
          // Simpler shadow for better performance
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withAlpha(15),
              blurRadius: 8,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: child,
      );
    }

    // On desktop, use the glass effect with backdrop filter
    return RepaintBoundary(
      // Add RepaintBoundary to isolate repainting
      child: ClipRRect(
        borderRadius: BorderRadius.circular(DesignSystem.radiusLg),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 8,
            sigmaY: 8,
          ), // Reduced blur for better performance
          child: Container(
            padding: DesignSystem.getCardPadding(context),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withAlpha(180),
              borderRadius: BorderRadius.circular(DesignSystem.radiusLg),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withAlpha(50),
                width: 1,
              ),
              // Simpler shadow for better performance
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withAlpha(15),
                  blurRadius: 10,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage(BuildContext context) {
    // Reduce parallax intensity on mobile for better performance
    final parallaxIntensity = Helpers.isMobile(context) ? 15.0 : 30.0;
    final imageSize = Helpers.isMobile(context) ? 280.0 : 320.0;

    return Center(
      child: RepaintBoundary(
        // Add RepaintBoundary to isolate repainting
        child: ParallaxEffect(
          intensity: parallaxIntensity,
          enableScrollEffect: true,
          // Disable mouse tracking on mobile for better performance
          enableMouseTracking: !Helpers.isMobile(context),
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
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withAlpha(100),
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
      ),
    );
  }

  Widget _buildTextContent(BuildContext context) {
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
          _buildHighlightedText(context, AppConstants.aboutMe, [
            'Flutter',
            'mobile applications',
            'responsive',
            'user-friendly',
          ]),

          const SizedBox(height: DesignSystem.spacingLg),

          // Stats section
          _buildStatsSection(context),

          const SizedBox(height: DesignSystem.spacingLg),

          // Action buttons with individual parallax effects and responsive layout
          SlideRevealTransition(
            duration: const Duration(milliseconds: 800),
            delay: const Duration(milliseconds: 1000),
            direction: SlideDirection.up,
            child: Wrap(
              spacing: DesignSystem.spacingMd,
              runSpacing: DesignSystem.spacingMd,
              alignment:
                  Helpers.isMobile(context)
                      ? WrapAlignment.center
                      : WrapAlignment.start,
              children: [
                // Download Resume button with its own parallax effect
                ParallaxEffect(
                  intensity: 25.0,
                  enableScrollEffect: true,
                  child: HoverEffect(
                    scale: 1.05,
                    enableElevation: true,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Download resume functionality
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
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),

                // Contact Me button with its own parallax effect
                ParallaxEffect(
                  intensity: 15.0,
                  enableScrollEffect: true,
                  child: HoverEffect(
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
                ),
              ],
            ),
          ),

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

  Widget _buildHighlightedText(
    BuildContext context,
    String text,
    List<String> highlightTerms,
  ) {
    // Create a RichText with highlighted terms
    final TextStyle baseStyle = Theme.of(context).textTheme.bodyLarge!;
    final TextStyle highlightStyle = baseStyle.copyWith(
      color: Theme.of(context).colorScheme.primary,
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.none,
    );

    final List<TextSpan> spans = [];
    String remainingText = text;

    for (final term in highlightTerms) {
      if (remainingText.contains(term)) {
        final parts = remainingText.split(term);
        if (parts.isNotEmpty) {
          spans.add(TextSpan(text: parts.first, style: baseStyle));
          spans.add(TextSpan(text: term, style: highlightStyle));
          remainingText = parts.sublist(1).join(term);
        }
      }
    }

    if (remainingText.isNotEmpty) {
      spans.add(TextSpan(text: remainingText, style: baseStyle));
    }

    return SlideRevealTransition(
      duration: const Duration(milliseconds: 800),
      delay: const Duration(milliseconds: 800),
      direction: SlideDirection.up,
      child: RichText(text: TextSpan(children: spans)),
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    final stats = [
      {'label': 'Years Experience', 'value': '3+'},
      {'label': 'Projects Completed', 'value': '15+'},
      {'label': 'Clients', 'value': '10+'},
    ];

    return SlideRevealTransition(
      duration: const Duration(milliseconds: 800),
      delay: const Duration(milliseconds: 900),
      direction: SlideDirection.up,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:
            stats.map((stat) {
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: DesignSystem.spacingXs,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: DesignSystem.spacingSm,
                    horizontal: DesignSystem.spacingXs,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(DesignSystem.radiusMd),
                    color: Theme.of(context).colorScheme.primary.withAlpha(15),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withAlpha(30),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        stat['value']!,
                        style: Theme.of(
                          context,
                        ).textTheme.headlineMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: DesignSystem.spacingXxs),
                      Text(
                        stat['label']!,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
