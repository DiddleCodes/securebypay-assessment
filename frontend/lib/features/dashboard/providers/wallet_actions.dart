import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/dashboard_repository.dart';
import 'dashboard_providers.dart';
import 'shipments_controller.dart';

final walletActionsProvider = Provider(WalletActions.new);

/// Money-moving actions; each refreshes the parts of the dashboard it affects.
class WalletActions {
  WalletActions(this._ref);

  final Ref _ref;

  DashboardRepository get _repository => _ref.read(dashboardRepositoryProvider);

  Future<void> fund(int amountKobo) async {
    await _repository.fundWallet(amountKobo);
    _ref.invalidate(overviewProvider);
  }

  Future<void> pay(String trackingId) async {
    final result = await _repository.payForShipment(trackingId);
    _ref.read(shipmentsControllerProvider.notifier).replace(result.shipment);
    _ref.invalidate(overviewProvider);
  }
}
