import 'package:flutter/material.dart';

import '../../../core/theme/app_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../data/overview.dart';

enum StatKind {
  shipments(
    'Total Shipment',
    AppIcons.truck,
    AppColors.shipmentIconBackground,
    AppColors.shipmentIcon,
  ),
  exports('Total Exports', AppIcons.arrowUp, AppColors.exportIconBackground, AppColors.exportIcon),
  imports('Total Import', AppIcons.arrowDown, AppColors.importIconBackground, AppColors.importIcon);

  const StatKind(this.label, this.icon, this.background, this.foreground);

  final String label;
  final IconData icon;
  final Color background;
  final Color foreground;
}

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.kind,
    required this.stat,
    required this.comparisonLabel,
  });

  final StatKind kind;
  final StatComparison stat;
  final String comparisonLabel;

  @override
  Widget build(BuildContext context) {
    final change = stat.changePercent;

    return Container(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 18, AppSpacing.lg, 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: kind.background, shape: BoxShape.circle),
                child: Icon(kind.icon, size: 24, color: kind.foreground),
              ),
              const SizedBox(width: AppSpacing.sm),
              Flexible(
                child: Text(
                  kind.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.statLabel,
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('${stat.count}', style: AppTextStyles.statValue),
              if (change != null) ...[
                const SizedBox(width: AppSpacing.sm),
                _Change(percent: change),
              ],
            ],
          ),
          const SizedBox(height: 5),
          Text.rich(
            TextSpan(
              style: AppTextStyles.comparisonLabel,
              children: [
                TextSpan(text: '$comparisonLabel: '),
                TextSpan(text: '${stat.previousCount}', style: AppTextStyles.comparisonValue),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Change extends StatelessWidget {
  const _Change({required this.percent});

  final int percent;

  @override
  Widget build(BuildContext context) {
    final up = percent >= 0;
    final color = up ? AppColors.positive : AppColors.error;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(up ? AppIcons.arrowUp : AppIcons.arrowDown, size: 12, color: color),
        const SizedBox(width: 2),
        Text('${percent.abs()}%', style: AppTextStyles.changePositive.copyWith(color: color)),
      ],
    );
  }
}
