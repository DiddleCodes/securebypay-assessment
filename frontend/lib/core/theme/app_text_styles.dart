import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTextStyles {
  static const fontFamily = 'DMSans';

  static const _base = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w400,
    height: 1.4,
    // Matches Figma/CSS, which split extra line height evenly above and below the glyphs
    leadingDistribution: TextLeadingDistribution.even,
  );

  static final authTitle = _base.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );
  static final authSubtitle = _base.copyWith(
    fontSize: 14,
    height: 22 / 14,
    color: AppColors.textSecondary,
  );
  static final panelHeadline = _base.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.onPrimary,
    height: 35 / 24,
  );
  static final panelBody = _base.copyWith(
    fontSize: 18,
    color: AppColors.onBrand,
    height: 30 / 18,
  );

  static final pageTitle = _base.copyWith(fontSize: 20, fontWeight: FontWeight.w600, height: 1.3);
  static final pageSubtitle = _base.copyWith(
    fontSize: 12,
    color: AppColors.textMuted,
    height: 20 / 12,
  );
  static final userName = _base.copyWith(
    fontSize: 14,
    color: AppColors.textSecondary,
    height: 20 / 14,
  );
  static final sectionTitle = _base.copyWith(fontSize: 24, fontWeight: FontWeight.w600);
  static final cardTitle = _base.copyWith(fontSize: 18, color: AppColors.textHeading);

  static final label = _base.copyWith(fontSize: 16, height: 1.25);
  static final fieldError = _base.copyWith(fontSize: 12, color: AppColors.error, height: 1.3);
  static final input = _base.copyWith(fontSize: 16, height: 1.25);
  static final body = _base.copyWith(fontSize: 16);
  static final bodySmall = _base.copyWith(fontSize: 14);
  static final caption = _base.copyWith(fontSize: 12, color: AppColors.textSecondary);
  static final captionSmall = _base.copyWith(fontSize: 10, color: AppColors.textSecondary);

  static final button = _base.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.onBrand,
    height: 1.0,
  );
  static final link = _base.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    height: 22 / 14,
    decoration: TextDecoration.underline,
    decorationColor: AppColors.primary,
  );
  static final navItem = _base.copyWith(fontSize: 16, color: AppColors.textSecondary, height: 1.25);
  static final navItemActive = navItem.copyWith(
    fontWeight: FontWeight.w600,
    color: AppColors.onBrand,
  );

  static final balance = _base.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.onPrimary,
  );
  static final statValue = _base.copyWith(fontSize: 24, fontWeight: FontWeight.w500);
  static final changePositive = _base.copyWith(
    fontSize: 12,
    color: AppColors.positive,
    height: 1.0,
  );
  static final fieldLabel = _base.copyWith(fontSize: 12, color: AppColors.textLabel);
  static final fieldValue = _base.copyWith(fontSize: 16, color: AppColors.textBody);
  static final badge = _base.copyWith(fontSize: 12, fontWeight: FontWeight.w500, height: 1.0);
}
