import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../data/growth.dart';

class RangeToggle extends StatelessWidget {
  const RangeToggle({
    super.key,
    required this.value,
    required this.onChanged,
    this.compact = false,
  });

  final GrowthRange value;
  final ValueChanged<GrowthRange> onChanged;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final segmentWidth = compact ? 68.0 : 87.8;

    return Container(
      height: 40,
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.segmentTrack,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final range in GrowthRange.values)
            Semantics(
              button: true,
              selected: range == value,
              child: GestureDetector(
                onTap: () => onChanged(range),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: segmentWidth,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: range == value ? AppColors.surface : Colors.transparent,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      boxShadow: range == value
                          ? const [
                              BoxShadow(
                                color: Color(0x0F101828),
                                blurRadius: 2,
                                offset: Offset(0, 1),
                              ),
                            ]
                          : null,
                    ),
                    child: Text(
                      range.label,
                      style: range == value ? AppTextStyles.segmentSelected : AppTextStyles.segment,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
