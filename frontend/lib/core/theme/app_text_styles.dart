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

  static final authTitle = _base.copyWith(fontSize: 32, fontWeight: FontWeight.w700, height: 1.3);
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
  static final panelBody = _base.copyWith(fontSize: 18, color: AppColors.onBrand, height: 30 / 18);

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
  static final sectionTitle = _base.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    height: 1.3,
    letterSpacing: -0.5,
  );
  static final cardTitle = _base.copyWith(
    fontSize: 18,
    color: AppColors.textHeading,
    height: 26 / 18,
  );
  static final bannerHeadline = _base.copyWith(
    fontSize: 44,
    fontWeight: FontWeight.w700,
    color: AppColors.onPrimary,
    height: 1.0,
    letterSpacing: -1.5,
  );
  static final filterButton = _base.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
    height: 1.0,
  );
  static final segment = _base.copyWith(fontSize: 16, color: AppColors.segmentText, height: 1.0);
  static final segmentSelected = segment.copyWith(
    fontWeight: FontWeight.w500,
    color: AppColors.segmentSelectedText,
  );
  static final chartAxis = _base.copyWith(fontSize: 12, color: AppColors.chartAxis, height: 1.0);

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

  static final balanceLabel = _base.copyWith(
    fontSize: 12,
    color: AppColors.balanceLabel,
    height: 16 / 12,
  );
  static final balance = _base.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.balanceAmount,
    height: 32 / 24,
  );
  static final smallButton = _base.copyWith(fontSize: 12, fontWeight: FontWeight.w500, height: 1.0);
  static final statLabel = _base.copyWith(
    fontSize: 12,
    color: AppColors.textSecondary,
    height: 1.3,
  );
  static const statFontFamily = 'Montserrat';
  static final statValue = _base.copyWith(
    fontFamily: statFontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: AppColors.textBody,
    height: 1.3,
  );
  static final comparisonLabel = _base.copyWith(
    fontFamily: statFontFamily,
    fontSize: 8,
    color: AppColors.textBody,
    height: 2,
    letterSpacing: 8 * 0.004,
  );
  static final comparisonValue = _base.copyWith(
    fontFamily: statFontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textBody,
    height: 16 / 11,
    letterSpacing: 11 * 0.005,
  );
  static final changePositive = _base.copyWith(
    fontSize: 12,
    color: AppColors.positive,
    height: 1.0,
  );
  static final fieldLabel = _base.copyWith(
    fontSize: 12,
    color: AppColors.textLabel,
    height: 16 / 12,
  );
  static final fieldValue = _base.copyWith(fontSize: 16, color: AppColors.textPrimary, height: 1.5);
  static final locationValue = fieldValue.copyWith(fontSize: 14, height: 22 / 14);
  static final badge = _base.copyWith(fontSize: 12, height: 1.0);
  static final cardAction = _base.copyWith(fontSize: 12, fontWeight: FontWeight.w600, height: 1.0);
}
