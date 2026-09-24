import 'package:flutter/material.dart';

import '../../../core/theme/app_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class PageHeader extends StatelessWidget {
  const PageHeader({super.key, required this.title, required this.subtitle, this.onMenuTap});

  final String title;
  final String subtitle;

  /// Shows a menu button that opens the navigation drawer when set.
  final VoidCallback? onMenuTap;

  @override
  Widget build(BuildContext context) {
    final compact = onMenuTap != null;

    return Container(
      // Fixed at the design's 96px on desktop; the compact header grows with its wrapped subtitle
      height: compact ? null : AppSpacing.headerHeight,
      constraints: const BoxConstraints(minHeight: AppSpacing.headerHeight),
      padding: compact
          ? const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.contentGutter,
              AppSpacing.md,
            )
          : const EdgeInsets.fromLTRB(AppSpacing.contentGutter, 15, AppSpacing.contentGutter, 0),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        crossAxisAlignment: compact ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          if (compact) ...[
            IconButton(
              onPressed: onMenuTap,
              tooltip: 'Open navigation',
              icon: const Icon(AppIcons.menu, color: AppColors.textPrimary),
            ),
            const SizedBox(width: AppSpacing.xs),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: AppTextStyles.pageTitle),
                const SizedBox(height: 4),
                ConstrainedBox(
                  // Wraps after "see all" like the design
                  constraints: const BoxConstraints(maxWidth: 470),
                  child: Text(
                    subtitle,
                    maxLines: compact ? 2 : null,
                    overflow: compact ? TextOverflow.ellipsis : null,
                    style: AppTextStyles.pageSubtitle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
