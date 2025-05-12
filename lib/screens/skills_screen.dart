import 'package:flutter/material.dart';
import 'package:portfolio/models/skill.dart';
import 'package:portfolio/utils/helpers.dart';
import 'package:portfolio/config/design_system.dart';

class SkillsScreen extends StatelessWidget {
  const SkillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildContent(context);
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: DesignSystem.getSectionPadding(context),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section title
            Center(
              child: Text(
                'Skills & Technologies',
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),

            SizedBox(height: DesignSystem.spacingSm),

            // Section subtitle
            Center(
              child: Text(
                'My technical level',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),

            SizedBox(height: DesignSystem.spacingXl),

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
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignSystem.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category title
          Text(
            _getCategoryTitle(category),
            style: Theme.of(context).textTheme.headlineMedium,
          ),

          SizedBox(height: DesignSystem.spacingSm),

          // Skills list
          ...skills.map((skill) => _buildSkillItem(context, skill)),
        ],
      ),
    );
  }

  Widget _buildSkillItem(BuildContext context, Skill skill) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignSystem.spacingSm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Skill name and percentage
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(skill.name, style: Theme.of(context).textTheme.bodyLarge),
              Text(
                '${(skill.proficiency * 100).toInt()}%',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),

          SizedBox(height: DesignSystem.spacingXs),

          // Progress bar
          LinearProgressIndicator(
            value: skill.proficiency,
            backgroundColor: Theme.of(
              context,
            ).colorScheme.primary.withAlpha(51),
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
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
