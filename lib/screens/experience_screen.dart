import 'package:flutter/material.dart';
import 'package:portfolio/models/experience.dart';
import 'package:portfolio/config/design_system.dart';

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
    return Padding(
      padding: DesignSystem.getSectionPadding(context),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section title
            Center(
              child: Text(
                'Experience & Education',
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),

            SizedBox(height: DesignSystem.spacingSm),

            // Section subtitle
            Center(
              child: Text(
                'My personal journey',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),

            SizedBox(height: DesignSystem.spacingLg),

            // Tab bar
            TabBar(
              controller: _tabController,
              tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor:
                  Theme.of(context).textTheme.bodyLarge?.color,
              indicatorColor: Theme.of(context).colorScheme.primary,
              indicatorWeight: 3,
              onTap: (index) {
                setState(() {});
              },
            ),

            SizedBox(height: DesignSystem.spacingLg),

            // Experience timeline
            SizedBox(
              height:
                  MediaQuery.of(context).size.height * 0.6, // Responsive height
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

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline
        Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(iconData, color: Colors.white, size: 20),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 100,
                color: Theme.of(context).colorScheme.primary.withAlpha(128),
              ),
          ],
        ),

        SizedBox(width: DesignSystem.spacingSm),

        // Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                experience.title,
                style: Theme.of(context).textTheme.headlineMedium,
              ),

              SizedBox(height: DesignSystem.spacingXxs),

              // Organization
              Text(
                experience.organization,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),

              SizedBox(height: DesignSystem.spacingXxs),

              // Period
              Text(
                experience.period,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
              ),

              SizedBox(height: DesignSystem.spacingXs),

              // Description
              Text(
                experience.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              SizedBox(height: DesignSystem.spacingMd),
            ],
          ),
        ),
      ],
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
