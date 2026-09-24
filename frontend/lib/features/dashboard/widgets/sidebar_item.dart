import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class SidebarItem extends StatelessWidget {
  const SidebarItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
  });

  static const width = 180.0;
  static const height = 56.0;

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? AppColors.onBrand : AppColors.textSecondary;

    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected ? AppColors.navy : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.md),
          hoverColor: selected ? null : AppColors.background,
          child: SizedBox(
            width: width,
            height: height,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  Icon(icon, size: 24, color: foreground),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: selected ? AppTextStyles.navItemActive : AppTextStyles.navItem,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
