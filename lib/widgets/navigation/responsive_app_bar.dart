import 'package:flutter/material.dart';
import 'package:portfolio/config/routes.dart';
import 'package:portfolio/config/design_system.dart';
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
    // Get screen dimensions and orientation
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    final isVerySmallScreen = width < 360;
    final isMobile = Helpers.isMobile(context);

    // Use responsive font size for app bar title
    final titleStyle = Theme.of(context).textTheme.headlineMedium?.copyWith(
      fontSize: DesignSystem.getResponsiveFontSize(
        context,
        Theme.of(context).textTheme.headlineMedium?.fontSize ?? 24.0,
      ),
    );

    return AppBar(
      title: Text(
        isVerySmallScreen
            ? 'Portfolio'
            : AppConstants.name, // Use shorter title on very small screens
        style: titleStyle,
        overflow: TextOverflow.ellipsis, // Prevent text overflow
      ),
      centerTitle: isMobile, // Center title on mobile for better appearance
      elevation: 4.0, // Add elevation for better visual separation
      actions:
          isMobile
              ? [
                const ThemeSwitcher(isCompact: true),
                IconButton(
                  icon: const Icon(Icons.menu),
                  tooltip: 'Menu', // Add tooltip for accessibility
                  onPressed: () {
                    _showDrawer(context);
                  },
                ),
                // Add padding at the end for better touch targets
                const SizedBox(width: 4),
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
    // Get screen dimensions
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    final height = screenSize.height;
    final isLandscape = width > height;
    final isVerySmallScreen = width < 360;

    // Use responsive font sizes
    final nameStyle = Theme.of(context).textTheme.headlineMedium?.copyWith(
      color: Colors.white,
      fontSize: DesignSystem.getResponsiveFontSize(
        context,
        Theme.of(context).textTheme.headlineMedium?.fontSize ?? 24.0,
      ),
    );

    final titleStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
      color: Colors.white70,
      fontSize: DesignSystem.getResponsiveFontSize(
        context,
        Theme.of(context).textTheme.bodyLarge?.fontSize ?? 16.0,
      ),
    );

    // Adjust drawer header height for landscape mode
    final drawerHeaderHeight = isLandscape ? 120.0 : 160.0;

    return Drawer(
      width:
          isVerySmallScreen
              ? width * 0.85
              : null, // Adjust width for very small screens
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: drawerHeaderHeight,
              child: DrawerHeader(
                padding: EdgeInsets.symmetric(
                  vertical: isLandscape ? 8.0 : 16.0,
                  horizontal: 16.0,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isVerySmallScreen ? 'Portfolio' : AppConstants.name,
                        style: nameStyle,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppConstants.title,
                        style: titleStyle,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero, // Remove default padding
                physics: const BouncingScrollPhysics(), // Smoother scrolling
                children: _buildDrawerItems(context),
              ),
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: ThemeSwitcher(),
            ),
          ],
        ),
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
