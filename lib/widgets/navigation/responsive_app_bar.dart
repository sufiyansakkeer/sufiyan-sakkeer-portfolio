import 'package:flutter/material.dart';
import 'package:portfolio/config/routes.dart';
import 'package:portfolio/utils/constants.dart';
import 'package:portfolio/utils/helpers.dart';
import 'package:portfolio/widgets/theme_switcher.dart';

class ResponsiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String currentRoute;
  final Function(int)? onSectionSelected;

  const ResponsiveAppBar({
    super.key,
    required this.currentRoute,
    this.onSectionSelected,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        AppConstants.name,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      actions:
          Helpers.isMobile(context)
              ? [
                const ThemeSwitcher(isCompact: true),
                IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    _showDrawer(context);
                  },
                ),
              ]
              : [
                ..._buildNavItems(context),
                const SizedBox(width: 16),
                const ThemeSwitcher(isCompact: true),
                const SizedBox(width: 16),
              ],
    );
  }

  List<Widget> _buildNavItems(BuildContext context) {
    final navItems = [
      _NavItem(title: 'About', route: AppRoutes.about, index: 0),
      _NavItem(title: 'Skills', route: AppRoutes.skills, index: 1),
      _NavItem(title: 'Projects', route: AppRoutes.projects, index: 2),
      _NavItem(title: 'Experience', route: AppRoutes.experience, index: 3),
      _NavItem(title: 'Contact', route: AppRoutes.contact, index: 4),
    ];

    return navItems.map((item) {
      final isSelected = currentRoute == item.route;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: TextButton(
          onPressed: () {
            if (onSectionSelected != null) {
              onSectionSelected!(item.index);
            } else if (!isSelected) {
              Navigator.pushNamed(context, item.route);
            }
          },
          style: TextButton.styleFrom(
            foregroundColor:
                isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).textTheme.bodyLarge?.color,
          ),
          child: Text(
            item.title,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              decoration: isSelected ? TextDecoration.underline : null,
              decorationThickness: 2,
            ),
          ),
        ),
      );
    }).toList();
  }

  void _showDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }
}

class CustomNavigationDrawer extends StatelessWidget {
  final String currentRoute;
  final Function(int)? onSectionSelected;

  const CustomNavigationDrawer({
    super.key,
    required this.currentRoute,
    this.onSectionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppConstants.name,
                    style: Theme.of(
                      context,
                    ).textTheme.headlineMedium?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppConstants.title,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
          ..._buildDrawerItems(context),
          const Spacer(),
          const Padding(padding: EdgeInsets.all(16.0), child: ThemeSwitcher()),
        ],
      ),
    );
  }

  List<Widget> _buildDrawerItems(BuildContext context) {
    final navItems = [
      _NavItem(title: 'About', route: AppRoutes.about, index: 0),
      _NavItem(title: 'Skills', route: AppRoutes.skills, index: 1),
      _NavItem(title: 'Projects', route: AppRoutes.projects, index: 2),
      _NavItem(title: 'Experience', route: AppRoutes.experience, index: 3),
      _NavItem(title: 'Contact', route: AppRoutes.contact, index: 4),
    ];

    return navItems.map((item) {
      final isSelected = currentRoute == item.route;

      return ListTile(
        title: Text(
          item.title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color:
                isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        leading: _getIconForRoute(item.route),
        onTap: () {
          if (onSectionSelected != null) {
            onSectionSelected!(item.index);
          } else {
            Navigator.pop(context); // Close drawer
            if (!isSelected) {
              Navigator.pushNamed(context, item.route);
            }
          }
        },
      );
    }).toList();
  }

  Icon _getIconForRoute(String route) {
    switch (route) {
      case AppRoutes.about:
        return const Icon(Icons.person);
      case AppRoutes.skills:
        return const Icon(Icons.code);
      case AppRoutes.projects:
        return const Icon(Icons.work);
      case AppRoutes.experience:
        return const Icon(Icons.timeline);
      case AppRoutes.contact:
        return const Icon(Icons.email);
      default:
        return const Icon(Icons.home);
    }
  }
}

class _NavItem {
  final String title;
  final String route;
  final int index;

  _NavItem({required this.title, required this.route, required this.index});
}
