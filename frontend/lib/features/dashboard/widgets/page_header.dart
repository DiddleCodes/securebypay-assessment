import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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
      constraints: const BoxConstraints(minHeight: AppSpacing.headerHeight),
      padding: EdgeInsets.fromLTRB(
        compact ? AppSpacing.md : AppSpacing.contentGutter,
        compact ? AppSpacing.md : 15,
        AppSpacing.contentGutter,
        AppSpacing.md,
      ),
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
              icon: const Icon(LucideIcons.menu, color: AppColors.textPrimary),
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
