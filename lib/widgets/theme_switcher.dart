import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:portfolio/config/theme_provider.dart';
import 'package:portfolio/config/design_system.dart';
import 'package:portfolio/widgets/hover_effect.dart';

class ThemeSwitcher extends StatelessWidget {
  final bool isCompact;

  const ThemeSwitcher({super.key, this.isCompact = false});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return isCompact
        ? _buildCompactSwitcher(themeProvider)
        : _buildFullSwitcher(themeProvider);
  }

  Widget _buildCompactSwitcher(ThemeProvider themeProvider) {
    return Builder(
      builder: (context) {
        return HoverEffect(
          scale: 1.1,
          enableElevation: false,
          duration: DesignSystem.durationFast,
          child: IconButton(
            icon: AnimatedSwitcher(
              duration: DesignSystem.durationMedium,
              transitionBuilder: (Widget child, Animation<double> animation) {
                return RotationTransition(
                  turns: animation,
                  child: ScaleTransition(scale: animation, child: child),
                );
              },
              child: Icon(
                themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                key: ValueKey<bool>(themeProvider.isDarkMode),
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
            tooltip:
                themeProvider.isDarkMode
                    ? 'Switch to Light Mode'
                    : 'Switch to Dark Mode',
          ),
        );
      },
    );
  }

  Widget _buildFullSwitcher(ThemeProvider themeProvider) {
    return Builder(
      builder: (context) {
        return HoverEffect(
          scale: 1.05,
          enableElevation: true,
          elevationOnHover: DesignSystem.elevationSm,
          defaultElevation: 0,
          duration: DesignSystem.durationFast,
          child: InkWell(
            onTap: () {
              themeProvider.toggleTheme();
            },
            borderRadius: BorderRadius.circular(DesignSystem.radiusCircular),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignSystem.spacingSm,
                vertical: DesignSystem.spacingXs,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(
                  DesignSystem.radiusCircular,
                ),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withAlpha(50),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedSwitcher(
                    duration: DesignSystem.durationMedium,
                    transitionBuilder: (
                      Widget child,
                      Animation<double> animation,
                    ) {
                      return RotationTransition(
                        turns: animation,
                        child: ScaleTransition(scale: animation, child: child),
                      );
                    },
                    child: Icon(
                      themeProvider.isDarkMode
                          ? Icons.light_mode
                          : Icons.dark_mode,
                      key: ValueKey<bool>(themeProvider.isDarkMode),
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: DesignSystem.spacingXs),
                  AnimatedSwitcher(
                    duration: DesignSystem.durationMedium,
                    child: Text(
                      themeProvider.isDarkMode ? 'Light Mode' : 'Dark Mode',
                      key: ValueKey<bool>(themeProvider.isDarkMode),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
