import 'package:flutter/material.dart';
import 'package:portfolio/widgets/page_reveal_transition.dart';

/// A widget that displays text with highlighted terms.
class HighlightedText extends StatelessWidget {
  final String text;
  final List<String> highlightTerms;
  final Duration duration;
  final Duration delay;
  final SlideDirection direction;

  const HighlightedText({
    super.key,
    required this.text,
    required this.highlightTerms,
    this.duration = const Duration(milliseconds: 800),
    this.delay = const Duration(milliseconds: 800),
    this.direction = SlideDirection.up,
  });

  @override
  Widget build(BuildContext context) {
    // Create a RichText with highlighted terms
    final TextStyle baseStyle = Theme.of(context).textTheme.bodyLarge!;
    final TextStyle highlightStyle = baseStyle.copyWith(
      color: Theme.of(context).colorScheme.primary,
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.none,
    );

    final List<TextSpan> spans = [];
    String remainingText = text;

    for (final term in highlightTerms) {
      if (remainingText.contains(term)) {
        final parts = remainingText.split(term);
        if (parts.isNotEmpty) {
          spans.add(TextSpan(text: parts.first, style: baseStyle));
          spans.add(TextSpan(text: term, style: highlightStyle));
          remainingText = parts.sublist(1).join(term);
        }
      }
    }

    if (remainingText.isNotEmpty) {
      spans.add(TextSpan(text: remainingText, style: baseStyle));
    }

    return SlideRevealTransition(
      duration: duration,
      delay: delay,
      direction: direction,
      child: RichText(text: TextSpan(children: spans)),
    );
  }
}
