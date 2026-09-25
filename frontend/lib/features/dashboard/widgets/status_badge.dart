import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../data/shipment.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final ShipmentStatus status;

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = switch (status) {
      ShipmentStatus.inTransit => (AppColors.inTransitBackground, AppColors.inTransitText),
      ShipmentStatus.delayed => (AppColors.delayedBackground, AppColors.delayedText),
      ShipmentStatus.delivered => (AppColors.deliveredBackground, AppColors.deliveredText),
      ShipmentStatus.pending => (AppColors.pendingBackground, AppColors.pendingText),
    };

    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Center(
        widthFactor: 1,
        child: Text(status.label, style: AppTextStyles.badge.copyWith(color: foreground)),
      ),
    );
  }
}
