import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/dashboard_repository.dart';
import '../data/shipment.dart';

class ShipmentsState {
  const ShipmentsState({
    required this.items,
    required this.page,
    required this.totalPages,
    this.isLoadingMore = false,
  });

  final List<Shipment> items;
  final int page;
  final int totalPages;
  final bool isLoadingMore;

  bool get hasMore => page < totalPages;

  ShipmentsState copyWith({
    List<Shipment>? items,
    int? page,
    int? totalPages,
    bool? isLoadingMore,
  }) => ShipmentsState(
    items: items ?? this.items,
    page: page ?? this.page,
    totalPages: totalPages ?? this.totalPages,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
  );
}

final shipmentsControllerProvider =
    AsyncNotifierProvider.autoDispose<ShipmentsController, ShipmentsState>(ShipmentsController.new);

/// Newest-first shipments, loaded a page at a time.
class ShipmentsController extends AsyncNotifier<ShipmentsState> {
  static const pageSize = 10;

  DashboardRepository get _repository => ref.read(dashboardRepositoryProvider);

  @override
  Future<ShipmentsState> build() async {
    final first = await _repository.getShipments(page: 1, limit: pageSize);
    return ShipmentsState(items: first.items, page: first.page, totalPages: first.totalPages);
  }

  /// Rethrows so the caller can report the failure; the loaded items are kept.
  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true));
    try {
      final next = await _repository.getShipments(page: current.page + 1, limit: pageSize);
      state = AsyncData(
        current.copyWith(
          items: [...current.items, ...next.items],
          page: next.page,
          totalPages: next.totalPages,
          isLoadingMore: false,
        ),
      );
    } catch (_) {
      state = AsyncData(current.copyWith(isLoadingMore: false));
      rethrow;
    }
  }

  void replace(Shipment updated) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(
      current.copyWith(
        items: [
          for (final shipment in current.items)
            shipment.trackingId == updated.trackingId ? updated : shipment,
        ],
      ),
    );
  }
}
