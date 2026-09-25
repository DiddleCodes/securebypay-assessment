import 'package:flutter/material.dart';

import '../theme/app_text_styles.dart';

class TextLink extends StatelessWidget {
  const TextLink(this.text, {super.key, required this.onTap, this.style});

  final String text;
  final VoidCallback onTap;
  final TextStyle? style;

  static WidgetSpan span(String text, {required VoidCallback onTap, TextStyle? style}) {
    return WidgetSpan(
      alignment: PlaceholderAlignment.baseline,
      baseline: TextBaseline.alphabetic,
      child: TextLink(text, onTap: onTap, style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      link: true,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: Text(text, style: style ?? AppTextStyles.link),
        ),
      ),
    );
  }
}
