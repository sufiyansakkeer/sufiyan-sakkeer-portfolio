import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio/utils/constants.dart';
import 'package:portfolio/utils/helpers.dart';

class SocialBar extends StatelessWidget {
  final bool isVertical;
  final double iconSize;
  final Color? iconColor;

  const SocialBar({
    super.key,
    this.isVertical = false,
    this.iconSize = 24.0,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final socialIcons = [
      _SocialItem(
        icon: FontAwesomeIcons.github,
        url: AppConstants.githubUrl,
        tooltip: 'GitHub',
      ),
      _SocialItem(
        icon: FontAwesomeIcons.linkedin,
        url: AppConstants.linkedinUrl,
        tooltip: 'LinkedIn',
      ),
      _SocialItem(
        icon: FontAwesomeIcons.envelope,
        url: 'mailto:${AppConstants.email}',
        tooltip: 'Email',
      ),
    ];

    if (isVertical) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: _buildSocialIcons(socialIcons, context),
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: _buildSocialIcons(socialIcons, context),
      );
    }
  }

  List<Widget> _buildSocialIcons(
    List<_SocialItem> items,
    BuildContext context,
  ) {
    final List<Widget> widgets = [];
    final color = iconColor ?? Theme.of(context).colorScheme.primary;

    for (int i = 0; i < items.length; i++) {
      widgets.add(
        Tooltip(
          message: items[i].tooltip,
          child: IconButton(
            icon: FaIcon(items[i].icon, size: iconSize, color: color),
            onPressed: () => Helpers.launchURL(items[i].url),
          ),
        ),
      );

      // Add spacing between icons
      if (i < items.length - 1) {
        if (isVertical) {
          widgets.add(SizedBox(height: iconSize * 0.5));
        } else {
          widgets.add(SizedBox(width: iconSize * 0.5));
        }
      }
    }

    return widgets;
  }
}

class _SocialItem {
  final IconData icon;
  final String url;
  final String tooltip;

  _SocialItem({required this.icon, required this.url, required this.tooltip});
}
