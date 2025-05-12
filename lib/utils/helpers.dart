import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:portfolio/config/design_system.dart';
import 'package:portfolio/widgets/hover_effect.dart';

class Helpers {
  // Launch URL helper
  static Future<void> launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  // Email helper
  static Future<void> sendEmail(
    String email, {
    String subject = '',
    String body = '',
  }) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {'subject': subject, 'body': body},
    );

    if (!await launchUrl(emailUri)) {
      throw Exception('Could not launch email client');
    }
  }

  // Responsive layout helper
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < DesignSystem.breakpointMobile;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= DesignSystem.breakpointMobile &&
      MediaQuery.of(context).size.width < DesignSystem.breakpointTablet;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= DesignSystem.breakpointTablet;

  // Get responsive padding
  static EdgeInsets getResponsivePadding(BuildContext context) {
    return DesignSystem.getPadding(context);
  }

  // Get responsive width
  static double getResponsiveWidth(BuildContext context) {
    return DesignSystem.getContentMaxWidth(context);
  }

  // Animation helper
  static Widget animateOnHover({
    required Widget child,
    double scale = 1.05,
    Duration duration = const Duration(milliseconds: 200),
  }) {
    return HoverEffect(
      scale: scale,
      enableElevation: false,
      duration: duration,
      curve: DesignSystem.curveStandard,
      child: child,
    );
  }

  // Hover effect for cards
  static Widget addHoverEffect({
    required Widget child,
    double elevationOnHover = DesignSystem.elevationMd,
    double defaultElevation = DesignSystem.elevationSm,
    Duration duration = const Duration(milliseconds: 200),
  }) {
    return HoverEffect(
      enableScale: false,
      elevationOnHover: elevationOnHover,
      defaultElevation: defaultElevation,
      duration: duration,
      curve: DesignSystem.curveStandard,
      child: child,
    );
  }
}
