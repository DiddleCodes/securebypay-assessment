import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTextStyles {
  static const fontFamily = 'DMSans';

  static const _base = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static final authTitle = _base.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
    height: 1.25,
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
  );
  static final panelBody = _base.copyWith(fontSize: 18, color: AppColors.onPrimary);

  static final pageTitle = _base.copyWith(fontSize: 20, fontWeight: FontWeight.w600);
  static final pageSubtitle = _base.copyWith(fontSize: 12, color: AppColors.textSecondary);
  static final sectionTitle = _base.copyWith(fontSize: 24, fontWeight: FontWeight.w600);
  static final cardTitle = _base.copyWith(fontSize: 18, color: AppColors.textHeading);

  static final label = _base.copyWith(fontSize: 16, height: 1.25);
  static final input = _base.copyWith(fontSize: 16, height: 1.25);
  static final body = _base.copyWith(fontSize: 16);
  static final bodySmall = _base.copyWith(fontSize: 14);
  static final caption = _base.copyWith(fontSize: 12, color: AppColors.textSecondary);
  static final captionSmall = _base.copyWith(fontSize: 10, color: AppColors.textSecondary);

  static final button = _base.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.onPrimary,
    height: 1.0,
  );
  static final link = _base.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    decoration: TextDecoration.underline,
    decorationColor: AppColors.primary,
  );
  static final navItem = _base.copyWith(fontSize: 16, color: AppColors.textSecondary, height: 1.25);
  static final navItemActive = navItem.copyWith(
    fontWeight: FontWeight.w600,
    color: AppColors.navActiveForeground,
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
