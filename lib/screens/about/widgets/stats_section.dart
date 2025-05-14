import 'package:flutter/material.dart';
import 'package:portfolio/config/design_system.dart';
import 'package:portfolio/widgets/page_reveal_transition.dart';

/// A widget that displays statistics in a row of cards.
class StatsSection extends StatelessWidget {
  final Duration duration;
  final Duration delay;
  final SlideDirection direction;

  const StatsSection({
    super.key,
    this.duration = const Duration(milliseconds: 800),
    this.delay = const Duration(milliseconds: 900),
    this.direction = SlideDirection.up,
  });

  @override
  Widget build(BuildContext context) {
    final stats = [
      {'label': 'Years Experience', 'value': '2+'},
      {'label': 'Projects Completed', 'value': '10+'},
      // {'label': 'Clients', 'value': '10+'},
    ];

    return SlideRevealTransition(
      duration: duration,
      delay: delay,
      direction: direction,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:
            stats.map((stat) {
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: DesignSystem.spacingXs,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: DesignSystem.spacingSm,
                    horizontal: DesignSystem.spacingXs,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(DesignSystem.radiusMd),
                    color: Theme.of(context).colorScheme.primary.withAlpha(15),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withAlpha(30),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        stat['value']!,
                        style: Theme.of(
                          context,
                        ).textTheme.headlineMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: DesignSystem.spacingXxs),
                      Text(
                        stat['label']!,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
