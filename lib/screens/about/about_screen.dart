import 'package:flutter/material.dart';
import 'package:portfolio/config/design_system.dart';
import 'package:portfolio/utils/helpers.dart';
import 'package:portfolio/screens/about/widgets/about_widgets.dart';

/// The About screen of the portfolio app.
/// Displays information about the developer, skills, and contact options.
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
        const AnimatedBackground(),

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
            child: SizedBox(
              height: 400, // Fixed height for the container
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none, // Ensure no clipping occurs
                fit:
                    StackFit
                        .loose, // Allow children to determine their own size
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
                  const ProfileImage(),

                  // Skill tags floating around - centered in the stack
                  const Center(child: FloatingSkillTags()),
                ],
              ),
            ),
          ),

          // Right side - Text content in glass card
          Expanded(flex: 7, child: GlassCard(child: const AboutTextContent())),
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
              clipBehavior: Clip.none, // Ensure no clipping occurs
              fit: StackFit.loose, // Allow children to determine their own size
              children: const [
                ProfileImage(),
                // Center the floating skill tags to ensure they're properly positioned
                Center(child: FloatingSkillTags(isMobile: true)),
              ],
            ),
          ),

          const SizedBox(height: DesignSystem.spacingLg),

          // Text content in glass card
          GlassCard(child: const AboutTextContent()),
        ],
      ),
    );
  }
}
