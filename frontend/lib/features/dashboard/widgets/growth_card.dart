import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/breakpoints.dart';
import '../../../core/widgets/section_error.dart';
import '../providers/dashboard_providers.dart';
import 'growth_chart.dart';
import 'range_toggle.dart';

class GrowthCard extends ConsumerWidget {
  const GrowthCard({super.key});

  static const _chartHeight = 270.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final range = ref.watch(growthRangeProvider);
    final growth = ref.watch(growthProvider);
    final mobile = ScreenSize.of(context).isMobile;

    final title = Text('Company Growth', style: AppTextStyles.cardTitle);
    final toggle = RangeToggle(
      value: range,
      compact: mobile,
      onChanged: ref.read(growthRangeProvider.notifier).select,
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (mobile) ...[
            title,
            const SizedBox(height: AppSpacing.md),
            Align(alignment: Alignment.centerLeft, child: toggle),
          ] else
            Row(
              children: [
                Expanded(child: title),
                toggle,
              ],
            ),
          const SizedBox(height: 22),
          SizedBox(
            height: _chartHeight,
            child: switch (growth) {
              AsyncValue(isLoading: true, hasValue: false) => const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              AsyncError(:final error) => SectionError(
                error: error,
                onRetry: () => ref.invalidate(growthProvider),
              ),
              // Keeps the previous range's chart on screen while the next one loads
              AsyncValue(:final value?) => Padding(
                padding: const EdgeInsets.only(top: 8),
                child: GrowthChart(points: value),
              ),
              _ => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
            },
          ),
        ],
      ),
    );
  }
}
