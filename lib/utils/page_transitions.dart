import 'package:flutter/material.dart';
import 'package:portfolio/config/design_system.dart';

/// Custom page transitions for the portfolio app
class PageTransitions {
  /// Fade transition
  static PageRouteBuilder<dynamic> fadeTransition(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = 0.0;
        const end = 1.0;
        const curve = DesignSystem.curveStandard;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var opacityAnimation = animation.drive(tween);

        return FadeTransition(
          opacity: opacityAnimation,
          child: child,
        );
      },
      transitionDuration: DesignSystem.durationMedium,
    );
  }

  /// Slide transition
  static PageRouteBuilder<dynamic> slideTransition(
    Widget page, {
    SlideDirection direction = SlideDirection.right,
  }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset.zero;
        
        switch (direction) {
          case SlideDirection.right:
            begin = const Offset(1.0, 0.0);
            break;
          case SlideDirection.left:
            begin = const Offset(-1.0, 0.0);
            break;
          case SlideDirection.up:
            begin = const Offset(0.0, 1.0);
            break;
          case SlideDirection.down:
            begin = const Offset(0.0, -1.0);
            break;
        }
        
        const end = Offset.zero;
        const curve = DesignSystem.curveStandard;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      transitionDuration: DesignSystem.durationMedium,
    );
  }

  /// Scale transition
  static PageRouteBuilder<dynamic> scaleTransition(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = 0.8;
        const end = 1.0;
        const curve = DesignSystem.curveStandard;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var scaleAnimation = animation.drive(tween);

        return ScaleTransition(
          scale: scaleAnimation,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      transitionDuration: DesignSystem.durationMedium,
    );
  }

  /// Combined transition (slide + fade)
  static PageRouteBuilder<dynamic> combinedTransition(
    Widget page, {
    SlideDirection direction = SlideDirection.right,
  }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset.zero;
        
        switch (direction) {
          case SlideDirection.right:
            begin = const Offset(0.2, 0.0);
            break;
          case SlideDirection.left:
            begin = const Offset(-0.2, 0.0);
            break;
          case SlideDirection.up:
            begin = const Offset(0.0, 0.2);
            break;
          case SlideDirection.down:
            begin = const Offset(0.0, -0.2);
            break;
        }
        
        const end = Offset.zero;
        const curve = DesignSystem.curveStandard;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: offsetAnimation,
            child: child,
          ),
        );
      },
      transitionDuration: DesignSystem.durationMedium,
    );
  }
}

/// Slide direction enum
enum SlideDirection {
  right,
  left,
  up,
  down,
}
