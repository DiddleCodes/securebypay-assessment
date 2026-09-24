import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/dashboard_repository.dart';
import '../data/growth.dart';
import '../data/overview.dart';

final overviewPeriodProvider = NotifierProvider<SelectionNotifier<OverviewPeriod>, OverviewPeriod>(
  () => SelectionNotifier(OverviewPeriod.thisMonth),
);

final growthRangeProvider = NotifierProvider<SelectionNotifier<GrowthRange>, GrowthRange>(
  () => SelectionNotifier(GrowthRange.year),
);

final overviewProvider = FutureProvider.autoDispose<Overview>((ref) {
  return ref.read(dashboardRepositoryProvider).getOverview(ref.watch(overviewPeriodProvider));
});

final growthProvider = FutureProvider.autoDispose<List<GrowthPoint>>((ref) {
  return ref.read(dashboardRepositoryProvider).getGrowth(ref.watch(growthRangeProvider));
});

class SelectionNotifier<T> extends Notifier<T> {
  SelectionNotifier(this._initial);

  final T _initial;

  @override
  T build() => _initial;

  void select(T value) => state = value;
}
