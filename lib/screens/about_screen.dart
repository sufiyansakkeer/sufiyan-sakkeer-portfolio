import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:portfolio/utils/constants.dart';
import 'package:portfolio/utils/helpers.dart';
import 'package:portfolio/widgets/social_bar.dart';
import 'package:portfolio/screens/home_screen.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildContent(context);
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: Helpers.getResponsivePadding(context),
      child: SingleChildScrollView(
        child:
            Helpers.isMobile(context)
                ? _buildMobileLayout(context)
                : _buildDesktopLayout(context),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left side - Profile image
        Expanded(flex: 4, child: _buildProfileImage(context)),

        const SizedBox(width: 40),

        // Right side - Text content
        Expanded(flex: 6, child: _buildTextContent(context)),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Profile image
        _buildProfileImage(context),

        const SizedBox(height: 32),

        // Text content
        _buildTextContent(context),
      ],
    );
  }

  Widget _buildProfileImage(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.primary.withAlpha(50),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(51), // 0.2 opacity
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.person,
              size: 100,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Hello, I\'m', style: Theme.of(context).textTheme.headlineMedium),

        const SizedBox(height: 8),

        Text(
          AppConstants.name,
          style: Theme.of(context).textTheme.displayLarge,
        ),

        const SizedBox(height: 16),

        AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(
              AppConstants.title,
              textStyle: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
              speed: const Duration(milliseconds: 100),
            ),
          ],
          totalRepeatCount: 1,
          displayFullTextOnTap: true,
        ),

        const SizedBox(height: 24),

        Text(
          AppConstants.aboutMe,
          style: Theme.of(context).textTheme.bodyLarge,
        ),

        const SizedBox(height: 32),

        Row(
          children: [
            ElevatedButton.icon(
              onPressed: () {
                // Download resume functionality
                // TODO: Implement resume download
              },
              icon: const Icon(Icons.download),
              label: const Text('Download Resume'),
            ),

            const SizedBox(width: 16),

            OutlinedButton.icon(
              onPressed: () {
                // Find the parent HomeScreen and scroll to contact section
                final homeScreenState =
                    context.findAncestorStateOfType<HomeScreenState>();
                if (homeScreenState != null) {
                  homeScreenState.scrollToSection(4); // Contact section index
                }
              },
              icon: const Icon(Icons.email),
              label: const Text('Contact Me'),
            ),
          ],
        ),

        const SizedBox(height: 32),

        const SocialBar(),
      ],
    );
  }
}
