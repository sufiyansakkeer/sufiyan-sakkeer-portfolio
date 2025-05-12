import 'package:flutter/material.dart';
import 'package:portfolio/config/routes.dart';
import 'package:portfolio/utils/helpers.dart';
import 'package:portfolio/widgets/navigation/responsive_app_bar.dart';
import 'package:portfolio/screens/about_screen.dart';
import 'package:portfolio/screens/skills_screen.dart';
import 'package:portfolio/screens/projects_screen.dart';
import 'package:portfolio/screens/experience_screen.dart';
import 'package:portfolio/screens/contact_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _sectionKeys = List.generate(5, (_) => GlobalKey());

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Method to scroll to a specific section
  void scrollToSection(int index) {
    final targetContext = _sectionKeys[index].currentContext;
    if (targetContext != null) {
      Scrollable.ensureVisible(
        targetContext,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveAppBar(
        currentRoute: AppRoutes.home,
        onSectionSelected: (index) => scrollToSection(index),
      ),
      endDrawer:
          Helpers.isMobile(context)
              ? CustomNavigationDrawer(
                currentRoute: AppRoutes.home,
                onSectionSelected: (index) {
                  Navigator.pop(context); // Close drawer
                  scrollToSection(index);
                },
              )
              : null,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            // About Section
            SectionContainer(key: _sectionKeys[0], child: const AboutScreen()),

            // Skills Section
            SectionContainer(key: _sectionKeys[1], child: const SkillsScreen()),

            // Projects Section
            SectionContainer(
              key: _sectionKeys[2],
              child: const ProjectsScreen(),
            ),

            // Experience Section
            SectionContainer(
              key: _sectionKeys[3],
              child: const ExperienceScreen(),
            ),

            // Contact Section
            SectionContainer(
              key: _sectionKeys[4],
              child: const ContactScreen(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        },
        tooltip: 'Scroll to top',
        child: const Icon(Icons.arrow_upward),
      ),
    );
  }
}

class SectionContainer extends StatelessWidget {
  final Widget child;

  const SectionContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height,
      ),
      padding: Helpers.getResponsivePadding(context),
      child: Center(
        child: SizedBox(
          width: Helpers.getResponsiveWidth(context),
          child: child,
        ),
      ),
    );
  }
}
