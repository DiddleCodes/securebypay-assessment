import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_button_styles.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_snack_bar.dart';
import '../../../core/widgets/section_error.dart';
import '../../../core/widgets/skeleton.dart';
import '../providers/shipments_controller.dart';
import 'growth_card.dart';
import 'section_header.dart';
import 'shipment_card.dart';

class RecentShipmentsSection extends ConsumerStatefulWidget {
  const RecentShipmentsSection({super.key});

  @override
  ConsumerState<RecentShipmentsSection> createState() => _RecentShipmentsSectionState();
}

class _RecentShipmentsSectionState extends ConsumerState<RecentShipmentsSection> {
  static const _recentCount = 3;
  bool _showAll = false;

  Future<void> _loadMore() async {
    try {
      await ref.read(shipmentsControllerProvider.notifier).loadMore();
    } on ApiException catch (e) {
      if (mounted) showAppSnackBar(context, e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final shipments = ref.watch(shipmentsControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          title: 'Recent shipment',
          trailing: OutlinedButton(
            style: AppButtonStyles.neutral,
            onPressed: () => setState(() => _showAll = !_showAll),
            child: Text(_showAll ? 'Show Less' : 'See All'),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        const GrowthCard(),
        const SizedBox(height: AppSpacing.sm),
        switch (shipments) {
          AsyncValue(isLoading: true, hasValue: false) => const _ListLoading(),
          AsyncData(:final value) when value.items.isEmpty => const _EmptyState(),
          AsyncData(:final value) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final (index, shipment)
                  in (_showAll ? value.items : value.items.take(_recentCount)).indexed) ...[
                if (index > 0) const SizedBox(height: AppSpacing.sm),
                ShipmentCard(
                  key: ValueKey(shipment.trackingId),
                  shipment: shipment,
                  initiallyExpanded: index < _recentCount,
                ),
              ],
              if (_showAll && value.hasMore) ...[
                const SizedBox(height: AppSpacing.lg),
                Center(
                  child: OutlinedButton(
                    style: AppButtonStyles.neutral,
                    onPressed: value.isLoadingMore ? null : _loadMore,
                    child: value.isLoadingMore
                        ? const SizedBox.square(
                            dimension: 14,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Load more'),
                  ),
                ),
              ],
            ],
          ),
          AsyncError(:final error) => SectionError(
            error: error,
            onRetry: () => ref.invalidate(shipmentsControllerProvider),
          ),
          _ => const _ListLoading(),
        },
      ],
    );
  }
}

class _ListLoading extends StatelessWidget {
  const _ListLoading();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < _RecentShipmentsSectionState._recentCount; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.sm),
          const Skeleton(height: 120, radius: AppRadius.md),
        ],
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Text(
        'No shipments yet. They will appear here once you book one.',
        textAlign: TextAlign.center,
        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
      ),
    );
  }
}
