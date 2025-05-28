import 'package:flutter/material.dart';
import 'package:portfolio/models/skill.dart';
import 'package:portfolio/utils/helpers.dart';
import 'package:portfolio/config/design_system.dart';
import 'package:portfolio/utils/animation_utilities.dart';
import 'package:portfolio/widgets/section_header.dart';
import 'package:portfolio/widgets/styled_card.dart';

class SkillsScreen extends StatelessWidget {
  const SkillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildContent(context);
  }

  Widget _buildContent(BuildContext context) {
    return SectionContainer(
      animationKey: 'skills-section',
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header with consistent styling
            SectionHeader(
              title: 'Skills & Technologies',
              subtitle: 'My technical level',
              animationKey: 'skills',
            ),

            // Skills categories
            _buildSkillCategories(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillCategories(BuildContext context) {
    // Group skills by category
    final Map<SkillCategory, List<Skill>> groupedSkills = {};

    for (final skill in sampleSkills) {
      if (!groupedSkills.containsKey(skill.category)) {
        groupedSkills[skill.category] = [];
      }
      groupedSkills[skill.category]!.add(skill);
    }

    return Helpers.isMobile(context)
        ? Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children:
              groupedSkills.entries.map((entry) {
                return _buildCategorySection(context, entry.key, entry.value);
              }).toList(),
        )
        : Column(
          children: [
            for (int i = 0; i < groupedSkills.length; i += 2)
              Padding(
                padding: const EdgeInsets.only(bottom: DesignSystem.spacingSm),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildCategorySection(
                        context,
                        groupedSkills.keys.elementAt(i),
                        groupedSkills.values.elementAt(i),
                      ),
                    ),
                    SizedBox(width: DesignSystem.spacingLg),
                    if (i + 1 < groupedSkills.length)
                      Expanded(
                        child: _buildCategorySection(
                          context,
                          groupedSkills.keys.elementAt(i + 1),
                          groupedSkills.values.elementAt(i + 1),
                        ),
                      )
                    else
                      Expanded(
                        child: Container(),
                      ), // Equal spacing instead of Spacer
                  ],
                ),
              ),
          ],
        );
  }

  Widget _buildCategorySection(
    BuildContext context,
    SkillCategory category,
    List<Skill> skills,
  ) {
    final categoryKey = category.toString().split('.').last;

    return AnimationUtilities.createVisibilityTriggeredAnimation(
      animationKey: 'skill-category-$categoryKey',
      slideOffset: const Offset(0, 0.1),
      rotateAngle:
          category.index.isEven
              ? 0.01
              : -0.01, // Alternate rotation for categories
      child: StyledCard(
        padding: const EdgeInsets.all(DesignSystem.spacingMd),
        enableHover: false,
        useGlassEffect: true,
        glassOpacity: 0.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category title
            Text(
              _getCategoryTitle(category),
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            const SizedBox(height: DesignSystem.spacingSm),

            // Divider for visual separation
            Divider(
              color: Theme.of(context).colorScheme.primary.withAlpha(51),
              thickness: 1,
            ),

            const SizedBox(height: DesignSystem.spacingSm),

            // Skills list with staggered animations
            ...AnimationUtilities.createStaggeredAnimations(
              children:
                  skills
                      .map((skill) => _buildSkillItem(context, skill))
                      .toList(),
              baseAnimationKey: 'skill-item-$categoryKey',
              staggerDelay: DesignSystem.delayShort,
              slideOffset: const Offset(0.1, 0),
              rotateAngle:
                  category.index.isEven
                      ? -0.005
                      : 0.005, // Alternate rotation for items within categories
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillItem(BuildContext context, Skill skill) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignSystem.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Skill name and percentage
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                skill.name,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignSystem.spacingXs,
                  vertical: DesignSystem.spacingXxs,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(DesignSystem.radiusXs),
                ),
                child: Text(
                  '${(skill.proficiency * 100).toInt()}%',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: DesignSystem.spacingXs),

          // Progress bar with animation
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: skill.proficiency),
            duration: DesignSystem.durationSlow,
            curve: DesignSystem.curveSmooth,
            builder: (context, value, _) {
              return LinearProgressIndicator(
                value: value,
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.primary.withAlpha(26),
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
                minHeight: 8,
                borderRadius: BorderRadius.circular(DesignSystem.radiusXs),
              );
            },
          ),
        ],
      ),
    );
  }

  String _getCategoryTitle(SkillCategory category) {
    switch (category) {
      case SkillCategory.language:
        return 'Programming Languages';
      case SkillCategory.framework:
        return 'Frameworks & Libraries';
      case SkillCategory.database:
        return 'Databases';
      case SkillCategory.tool:
        return 'Tools & Technologies';
      case SkillCategory.other:
        return 'Other Skills';
    }
  }
}
