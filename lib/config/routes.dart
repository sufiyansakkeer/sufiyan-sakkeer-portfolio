import 'package:flutter/material.dart';
import 'package:portfolio/screens/home_screen.dart';
import 'package:portfolio/screens/about_screen.dart';
import 'package:portfolio/screens/skills_screen.dart';
import 'package:portfolio/screens/projects_screen.dart';
import 'package:portfolio/screens/experience_screen.dart';
import 'package:portfolio/screens/contact_screen.dart';
import 'package:portfolio/utils/page_transitions.dart';

class AppRoutes {
  static const String home = '/';
  static const String about = '/about';
  static const String skills = '/skills';
  static const String projects = '/projects';
  static const String experience = '/experience';
  static const String contact = '/contact';

  // Generate route with custom page transitions
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return PageTransitions.fadeTransition(const HomeScreen());
      case about:
        return PageTransitions.combinedTransition(
          const AboutScreen(),
          direction: SlideDirection.right,
        );
      case skills:
        return PageTransitions.combinedTransition(
          const SkillsScreen(),
          direction: SlideDirection.right,
        );
      case projects:
        return PageTransitions.combinedTransition(
          const ProjectsScreen(),
          direction: SlideDirection.right,
        );
      case experience:
        return PageTransitions.combinedTransition(
          const ExperienceScreen(),
          direction: SlideDirection.right,
        );
      case contact:
        return PageTransitions.combinedTransition(
          const ContactScreen(),
          direction: SlideDirection.right,
        );
      default:
        return PageTransitions.fadeTransition(const HomeScreen());
    }
  }

  // For backward compatibility
  static Map<String, WidgetBuilder> get routes => {
    home: (context) => const HomeScreen(),
    about: (context) => const AboutScreen(),
    skills: (context) => const SkillsScreen(),
    projects: (context) => const ProjectsScreen(),
    experience: (context) => const ExperienceScreen(),
    contact: (context) => const ContactScreen(),
  };
}
