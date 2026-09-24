import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_button_styles.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../data/overview.dart';

class PeriodFilter extends StatelessWidget {
  const PeriodFilter({super.key, required this.value, required this.onChanged});

  final OverviewPeriod value;
  final ValueChanged<OverviewPeriod> onChanged;

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      alignmentOffset: const Offset(0, 4),
      menuChildren: [
        for (final period in OverviewPeriod.values)
          MenuItemButton(
            onPressed: () => onChanged(period),
            child: Text(
              period.label,
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: period == value ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
      ],
      builder: (context, controller, _) => OutlinedButton(
        style: AppButtonStyles.neutral,
        onPressed: () => controller.isOpen ? controller.close() : controller.open(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(value.label),
            const SizedBox(width: 6),
            const Icon(LucideIcons.chevronDown, size: 16, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
