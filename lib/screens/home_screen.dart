import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:portfolio/config/routes.dart';
import 'package:portfolio/utils/helpers.dart';
import 'package:portfolio/widgets/navigation/responsive_app_bar.dart';
import 'package:portfolio/screens/about_screen.dart';
import 'package:portfolio/screens/skills_screen.dart';
import 'package:portfolio/screens/projects_screen.dart';
import 'package:portfolio/screens/experience_screen.dart';
import 'package:portfolio/screens/contact_screen.dart';
import 'package:portfolio/widgets/custom_cursor.dart';
import 'package:portfolio/widgets/animated_section_container.dart';
import 'package:portfolio/widgets/simple_section_container.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _sectionKeys = List.generate(5, (_) => GlobalKey());
  int _activeSection = 0;
  bool _isScrolling = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (_isScrolling) return;

    // Calculate immediately without using Future to avoid BuildContext issues
    // Determine which section is most visible
    int mostVisibleSection = 0;
    double maxVisibleArea = 0;
    final screenHeight = MediaQuery.of(context).size.height;

    for (int i = 0; i < _sectionKeys.length; i++) {
      final key = _sectionKeys[i];
      final context = key.currentContext;

      if (context != null) {
        final RenderBox box = context.findRenderObject() as RenderBox;
        final position = box.localToGlobal(Offset.zero);
        final size = box.size;

        // Calculate how much of the section is visible
        final visibleTop = math.max(0.0, position.dy);
        final visibleBottom = math.min(screenHeight, position.dy + size.height);
        final visibleHeight = math.max(0.0, visibleBottom - visibleTop);

        if (visibleHeight > maxVisibleArea) {
          maxVisibleArea = visibleHeight;
          mostVisibleSection = i;
        }
      }
    }

    if (_activeSection != mostVisibleSection) {
      setState(() {
        _activeSection = mostVisibleSection;
      });
    }
  }

  // Method to scroll to a specific section
  void scrollToSection(int index) {
    final targetContext = _sectionKeys[index].currentContext;
    if (targetContext != null) {
      setState(() {
        _isScrolling = true;
        _activeSection = index;
      });

      Scrollable.ensureVisible(
        targetContext,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
      ).then((_) {
        setState(() {
          _isScrolling = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions and orientation
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    // final height = screenSize.height;
    // final isLandscape = width > height;
    final isMobile = Helpers.isMobile(context);

    // Define section background colors
    final List<Color> sectionColors = [
      Theme.of(context).colorScheme.surface,
      Theme.of(context).colorScheme.surface.withAlpha(247), // 0.97 opacity
      Theme.of(context).colorScheme.surface,
      Theme.of(context).colorScheme.surface.withAlpha(247), // 0.97 opacity
      Theme.of(context).colorScheme.surface,
    ];

    // Define section reveal colors
    final List<Color> revealColors = [
      Theme.of(context).colorScheme.primary,
      Theme.of(context).colorScheme.secondary,
      Theme.of(context).colorScheme.tertiary,
      Theme.of(context).colorScheme.primary.withAlpha(204), // 0.8 opacity
      Theme.of(context).colorScheme.secondary.withAlpha(204), // 0.8 opacity
    ];

    // Adjust parallax intensity based on device
    // final aboutParallaxIntensity = isMobile ? 15.0 : 30.0;
    final projectsParallaxIntensity = isMobile ? 10.0 : 20.0;

    return CustomCursor(
      cursorColor: Theme.of(context).colorScheme.primary,
      size: 12.0,
      hoverSize: 24.0,
      // Disable custom cursor on mobile devices
      enabled: !isMobile,
      child: Scaffold(
        appBar: ResponsiveAppBar(
          currentRoute: AppRoutes.home,
          onSectionSelected: (index) => scrollToSection(index),
        ),
        endDrawer:
            isMobile
                ? CustomNavigationDrawer(
                  currentRoute: AppRoutes.home,
                  onSectionSelected: (index) {
                    Navigator.pop(context); // Close drawer
                    scrollToSection(index);
                  },
                )
                : null,
        body: SafeArea(
          // Use SafeArea to handle notches and system UI overlays
          bottom: false, // Don't pad the bottom as we want full-screen sections
          child: SingleChildScrollView(
            controller: _scrollController,
            physics:
                const ClampingScrollPhysics(), // Smoother scrolling on mobile
            child: Column(
              children: [
                AboutScreen(key: _sectionKeys[0]),
                SimpleSectionContainer(
                  key: _sectionKeys[1],
                  backgroundColor: sectionColors[1],
                  child: const SkillsScreen(),
                ),

                // Projects Section
                AnimatedSectionContainer(
                  key: _sectionKeys[2],
                  isActive: _activeSection == 2,
                  backgroundColor: sectionColors[2],
                  revealColor: revealColors[2],
                  enableParallax:
                      false, // Disable parallax in landscape on mobile
                  parallaxIntensity: projectsParallaxIntensity,
                  animationDuration: const Duration(milliseconds: 800),
                  animationCurve: Curves.easeInOutCubic,
                  child: const ProjectsScreen(),
                ),

                // Experience Section
                SimpleSectionContainer(
                  key: _sectionKeys[3],
                  backgroundColor: sectionColors[3],
                  child: const ExperienceScreen(),
                ),

                // Contact Section
                SimpleSectionContainer(
                  key: _sectionKeys[4],
                  backgroundColor: sectionColors[4],
                  child: const ContactScreen(),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            scrollToSection(0);
          },
          tooltip: 'Scroll to top',
          // Adjust FAB position for mobile devices
          mini:
              isMobile && width < 400, // Use smaller FAB on very small screens
          child: const Icon(Icons.arrow_upward),
        ),
        // Adjust FAB position for better accessibility on mobile
        floatingActionButtonLocation:
            isMobile
                ? FloatingActionButtonLocation.endFloat
                : FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
