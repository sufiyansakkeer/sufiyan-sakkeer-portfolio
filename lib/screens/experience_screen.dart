import 'package:flutter/material.dart';
import 'package:portfolio/models/experience.dart';
import 'package:portfolio/config/design_system.dart';
import 'package:portfolio/utils/animation_utilities.dart';
import 'package:portfolio/widgets/section_header.dart';
import 'package:portfolio/widgets/styled_card.dart';

class ExperienceScreen extends StatefulWidget {
  const ExperienceScreen({super.key});

  @override
  State<ExperienceScreen> createState() => _ExperienceScreenState();
}

class _ExperienceScreenState extends State<ExperienceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['All', 'Work', 'Education', 'Publications'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent(context);
  }

  Widget _buildContent(BuildContext context) {
    return SectionContainer(
      animationKey: 'experience-section',
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header with consistent styling
            SectionHeader(
              title: 'Experience & Education',
              subtitle: 'My personal journey',
              animationKey: 'experience',
            ),

            const SizedBox(height: DesignSystem.spacingLg),

            // Modern styled tab bar
            AnimationUtilities.createVisibilityTriggeredAnimation(
              animationKey: 'experience-tabs',
              duration: DesignSystem.durationMedium,
              delay: DesignSystem.delayShort,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(DesignSystem.radiusMd),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(8),
                      blurRadius: 8,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: TabBar(
                  controller: _tabController,
                  tabs:
                      _tabs
                          .map(
                            (tab) => Tab(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: DesignSystem.spacingXs,
                                ),
                                child: Text(tab),
                              ),
                            ),
                          )
                          .toList(),
                  labelColor: Theme.of(context).colorScheme.onPrimary,
                  unselectedLabelColor: Theme.of(context).colorScheme.onSurface,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  indicator: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(DesignSystem.radiusMd),
                  ),
                  dividerColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  onTap: (index) {
                    setState(() {});
                  },
                ),
              ),
            ),

            const SizedBox(height: DesignSystem.spacingLg),

            // Experience timeline with improved styling
            AnimationUtilities.createVisibilityTriggeredAnimation(
              animationKey: 'experience-content',
              duration: DesignSystem.durationMedium,
              delay: DesignSystem.delayMedium,
              child: SizedBox(
                height:
                    MediaQuery.of(context).size.height *
                    0.6, // Responsive height
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildExperienceList(context, null),
                    _buildExperienceList(context, ExperienceType.work),
                    _buildExperienceList(context, ExperienceType.education),
                    _buildExperienceList(context, ExperienceType.publication),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExperienceList(BuildContext context, ExperienceType? type) {
    final filteredExperiences =
        type == null
            ? sampleExperiences
                .where((exp) => exp.type != ExperienceType.volunteer)
                .toList()
            : sampleExperiences.where((exp) => exp.type == type).toList();

    return ListView.builder(
      shrinkWrap: true,
      // Allow scrolling within the tab view
      physics: const ClampingScrollPhysics(),
      itemCount: filteredExperiences.length,
      itemBuilder: (context, index) {
        final isLast = index == filteredExperiences.length - 1;
        return _buildExperienceItem(
          context,
          filteredExperiences[index],
          isLast,
        );
      },
    );
  }

  Widget _buildExperienceItem(
    BuildContext context,
    Experience experience,
    bool isLast,
  ) {
    final iconData = _getIconForExperienceType(experience.type);
    final index = sampleExperiences.indexOf(experience);

    return AnimationUtilities.createVisibilityTriggeredAnimation(
      animationKey: 'experience-item-${experience.type}-$index',
      duration: DesignSystem.durationMedium,
      delay: Duration(milliseconds: index * 100),
      slideOffset: const Offset(0.1, 0),
      child: Padding(
        padding: const EdgeInsets.only(bottom: DesignSystem.spacingMd),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline with improved styling
            Column(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withAlpha(51),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Icon(iconData, color: Colors.white, size: 24),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 100,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.primary.withAlpha(51),
                        ],
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(width: DesignSystem.spacingMd),

            // Content in a styled card
            Expanded(
              child: StyledCard(
                padding: const EdgeInsets.all(DesignSystem.spacingMd),
                enableHover: true,
                useGlassEffect: true,
                glassOpacity: 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      experience.title,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: DesignSystem.spacingXs),

                    // Organization with badge
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: DesignSystem.spacingXs,
                            vertical: DesignSystem.spacingXxs,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(
                              DesignSystem.radiusXs,
                            ),
                          ),
                          child: Text(
                            experience.organization,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: DesignSystem.spacingXs),
                        Text(
                          experience.period,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),

                    const SizedBox(height: DesignSystem.spacingMd),

                    // Description
                    Text(
                      experience.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForExperienceType(ExperienceType type) {
    switch (type) {
      case ExperienceType.work:
        return Icons.work;
      case ExperienceType.education:
        return Icons.school;
      case ExperienceType.volunteer:
        return Icons.volunteer_activism;
      case ExperienceType.publication:
        return Icons.article;
    }
  }
}
