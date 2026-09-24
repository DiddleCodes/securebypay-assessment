import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_text_styles.dart';

abstract final class AppButtonStyles {
  static final _shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md));

  /// White with a light border, as used by "See All" and the period filter.
  static final neutral = OutlinedButton.styleFrom(
    foregroundColor: AppColors.textMuted,
    backgroundColor: AppColors.surface,
    side: const BorderSide(color: AppColors.border),
    shape: _shape,
    minimumSize: const Size(0, 34),
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
    textStyle: AppTextStyles.filterButton,
  );

  static final cardOutlined = OutlinedButton.styleFrom(
    foregroundColor: AppColors.navy,
    backgroundColor: AppColors.surface,
    side: const BorderSide(color: AppColors.navy),
    shape: _shape,
    fixedSize: const Size(91, 34),
    padding: EdgeInsets.zero,
    textStyle: AppTextStyles.cardAction,
  );

  static final cardFilled = FilledButton.styleFrom(
    foregroundColor: AppColors.onPrimary,
    backgroundColor: AppColors.navy,
    disabledBackgroundColor: AppColors.paidBackground,
    disabledForegroundColor: AppColors.paidText,
    shape: _shape,
    fixedSize: const Size(90, 34),
    padding: EdgeInsets.zero,
    textStyle: AppTextStyles.cardAction,
  );
}
