import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:portfolio/utils/image_cache_manager.dart';
import 'package:portfolio/models/project.dart';
import 'package:portfolio/models/skill.dart';
import 'package:portfolio/models/experience.dart';

/// A utility class for optimizing app performance
class PerformanceOptimizer {
  static final PerformanceOptimizer _instance =
      PerformanceOptimizer._internal();

  factory PerformanceOptimizer() => _instance;

  PerformanceOptimizer._internal();

  // Track if preloading has been done
  bool _hasPreloadedAssets = false;

  // Preload critical assets
  Future<void> preloadCriticalAssets(BuildContext context) async {
    if (_hasPreloadedAssets) return;

    // Preload project images
    final imagesToPreload = <String>[];

    // Add project images that are URLs (not asset paths)
    for (final project in sampleProjects) {
      if (!project.imageUrl.startsWith('assets/')) {
        imagesToPreload.add(project.imageUrl);
      }
    }

    // Add skill icons that are network images
    for (final skill in sampleSkills) {
      if (skill.isNetworkImage) {
        imagesToPreload.add(skill.iconPath);
      }
    }

    // Add experience logos that are network images
    for (final experience in sampleExperiences) {
      if (experience.logoUrl != null && experience.isNetworkImage) {
        imagesToPreload.add(experience.logoUrl!);
      }
    }

    // Preload network images
    if (imagesToPreload.isNotEmpty) {
      await AppImageCacheManager().preloadImages(imagesToPreload);
    }

    _hasPreloadedAssets = true;
  }

  // Optimize frame rate by adjusting timeDilation
  void optimizeFrameRate() {
    // Set time dilation to 1.0 for normal speed
    // Lower values speed up animations, higher values slow them down
    timeDilation = 1.0;
  }
}

/// A widget that optimizes performance by wrapping its child in a RepaintBoundary
class OptimizedWidget extends StatelessWidget {
  final Widget child;
  final bool useRepaintBoundary;

  const OptimizedWidget({
    super.key,
    required this.child,
    this.useRepaintBoundary = true,
  });

  @override
  Widget build(BuildContext context) {
    return useRepaintBoundary ? RepaintBoundary(child: child) : child;
  }
}

/// A widget that defers the building of expensive widgets until after the frame is rendered
class DeferredBuildWidget extends StatefulWidget {
  final WidgetBuilder builder;
  final Widget placeholder;
  final Duration deferDuration;

  const DeferredBuildWidget({
    super.key,
    required this.builder,
    required this.placeholder,
    this.deferDuration = const Duration(milliseconds: 100),
  });

  @override
  State<DeferredBuildWidget> createState() => _DeferredBuildWidgetState();
}

class _DeferredBuildWidgetState extends State<DeferredBuildWidget> {
  bool _shouldBuild = false;

  @override
  void initState() {
    super.initState();
    _scheduleDeferred();
  }

  void _scheduleDeferred() {
    Future.delayed(widget.deferDuration, () {
      if (mounted) {
        setState(() {
          _shouldBuild = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _shouldBuild ? widget.builder(context) : widget.placeholder;
  }
}
