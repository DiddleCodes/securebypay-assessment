import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/breakpoints.dart';
import '../../../core/widgets/text_link.dart';

class AuthHeading extends StatelessWidget {
  const AuthHeading({
    super.key,
    required this.title,
    required this.subtitle,
    required this.linkLabel,
    required this.onLinkTap,
    required this.maxWidth,
  });

  final String title;
  final String subtitle;
  final String linkLabel;
  final VoidCallback onLinkTap;

  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: ScreenSize.of(context).isMobile
                ? AppTextStyles.authTitle.copyWith(fontSize: 28)
                : AppTextStyles.authTitle,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text.rich(
            TextSpan(
              style: AppTextStyles.authSubtitle,
              children: [
                TextSpan(text: '$subtitle '),
                TextLink.span(linkLabel, onTap: onLinkTap),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
