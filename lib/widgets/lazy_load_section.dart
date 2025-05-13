import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// A widget that lazily loads its child when it becomes visible in the viewport.
/// This helps improve initial load performance by deferring the creation of
/// expensive widgets until they're needed.
class LazyLoadSection extends StatefulWidget {
  final Widget child;
  final Widget? placeholder;

  const LazyLoadSection({super.key, required this.child, this.placeholder});

  @override
  State<LazyLoadSection> createState() => _LazyLoadSectionState();
}

class _LazyLoadSectionState extends State<LazyLoadSection> {
  bool _isLoaded = false;
  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Schedule visibility check after the first frame
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _checkVisibility();
    });
  }

  void _checkVisibility() {
    // If already loaded, no need to check
    if (_isLoaded) return;

    final RenderObject? object = _key.currentContext?.findRenderObject();
    final BuildContext? buildContext = _key.currentContext;

    if (object == null || buildContext == null) {
      // Widget not rendered yet, check again later
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkVisibility();
      });
      return;
    }

    final RenderBox box = object as RenderBox;
    final position = box.localToGlobal(Offset.zero);
    // final size = box.size;
    final screenSize = MediaQuery.of(buildContext).size;

    // Check if the widget is close to being visible
    final isNearViewport = position.dy < screenSize.height * 1.5;

    if (isNearViewport) {
      setState(() {
        _isLoaded = true;
      });
    } else {
      // Not visible yet, check again after a short delay
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _checkVisibility();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _key,
      child:
          _isLoaded
              ? widget.child
              : widget.placeholder ??
                  SizedBox(
                    height: 500, // Default placeholder height
                    width: double.infinity,
                    child: Center(
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
    );
  }
}
