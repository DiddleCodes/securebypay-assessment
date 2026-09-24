import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/section_error.dart';
import '../../../core/widgets/skeleton.dart';
import '../data/overview.dart';
import '../providers/dashboard_providers.dart';
import 'balance_card.dart';
import 'period_filter.dart';
import 'section_header.dart';
import 'stat_card.dart';

class OverviewSection extends ConsumerWidget {
  const OverviewSection({super.key});

  static const _cardHeight = 165.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final period = ref.watch(overviewPeriodProvider);
    final overview = ref.watch(overviewProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          title: 'Overview',
          trailing: PeriodFilter(
            value: period,
            onChanged: ref.read(overviewPeriodProvider.notifier).select,
          ),
        ),
        const SizedBox(height: 23),
        switch (overview) {
          // Retrying after an error: show the skeleton rather than the stale error
          AsyncValue(isLoading: true, hasValue: false) => const _CardsLoading(),
          AsyncData(:final value) => _Cards(overview: value, period: period),
          AsyncError(:final error) => SectionError(
            error: error,
            height: _cardHeight,
            onRetry: () => ref.invalidate(overviewProvider),
          ),
          _ => const _CardsLoading(),
        },
      ],
    );
  }
}

class _Cards extends StatelessWidget {
  const _Cards({required this.overview, required this.period});

  final Overview overview;
  final OverviewPeriod period;

  @override
  Widget build(BuildContext context) {
    return _OverviewLayout(
      balance: BalanceCard(balance: overview.walletBalance),
      stats: [
        for (final (kind, stat) in [
          (StatKind.shipments, overview.totalShipments),
          (StatKind.exports, overview.exports),
          (StatKind.imports, overview.imports),
        ])
          StatCard(kind: kind, stat: stat, comparisonLabel: period.comparisonLabel),
      ],
    );
  }
}

class _CardsLoading extends StatelessWidget {
  const _CardsLoading();

  @override
  Widget build(BuildContext context) {
    return const _OverviewLayout(balance: Skeleton(), stats: [Skeleton(), Skeleton(), Skeleton()]);
  }
}

/// Wide: balance and three stats in one row (450 : 213 x 3 in the design).
/// Medium: balance on its own row with the stats below. Narrow: everything stacked.
/// Based on the space the section actually gets, since the sidebar takes 240px on desktop.
class _OverviewLayout extends StatelessWidget {
  const _OverviewLayout({required this.balance, required this.stats});

  static const _singleRowMinWidth = 900.0;
  static const _statRowMinWidth = 520.0;

  final Widget balance;
  final List<Widget> stats;

  @override
  Widget build(BuildContext context) {
    const height = OverviewSection._cardHeight;

    Widget statRow() => Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < stats.length; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.lg),
          Expanded(child: stats[i]),
        ],
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (width >= _singleRowMinWidth) {
          return SizedBox(
            height: height,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(flex: 450, child: balance),
                const SizedBox(width: AppSpacing.xl),
                Expanded(flex: 213 * 3 + 32, child: statRow()),
              ],
            ),
          );
        }

        if (width >= _statRowMinWidth) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: height, child: balance),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(height: 150, child: statRow()),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: height, child: balance),
            for (final stat in stats) ...[
              const SizedBox(height: AppSpacing.md),
              SizedBox(height: 136, child: stat),
            ],
          ],
        );
      },
    );
  }
}
