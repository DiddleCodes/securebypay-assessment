import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/currency.dart';
import '../../../core/widgets/section_error.dart';
import '../data/dashboard_repository.dart';
import '../data/shipment.dart';
import 'location_text.dart';
import 'status_badge.dart';

final _shipmentDetailsProvider = FutureProvider.autoDispose.family<Shipment, String>(
  (ref, trackingId) => ref.read(dashboardRepositoryProvider).getShipment(trackingId),
);

Future<void> showShipmentDetailsDialog(BuildContext context, String trackingId) {
  return showDialog(
    context: context,
    builder: (_) => _ShipmentDetailsDialog(trackingId: trackingId),
  );
}

class _ShipmentDetailsDialog extends ConsumerWidget {
  const _ShipmentDetailsDialog({required this.trackingId});

  final String trackingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final details = ref.watch(_shipmentDetailsProvider(trackingId));

    return AlertDialog(
      title: Text('Shipment details', style: AppTextStyles.pageTitle),
      content: SizedBox(
        width: 440,
        child: switch (details) {
          AsyncData(:final value) => _Details(shipment: value),
          AsyncError(:final error) => SectionError(
            error: error,
            onRetry: () => ref.invalidate(_shipmentDetailsProvider(trackingId)),
          ),
          _ => const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),
        },
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close')),
      ],
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({required this.shipment});

  final Shipment shipment;

  @override
  Widget build(BuildContext context) {
    final rows = <(String, Widget)>[
      (
        'Tracking ID',
        Text(
          shipment.trackingId,
          style: AppTextStyles.fieldValue.copyWith(color: AppColors.primary),
        ),
      ),
      (
        'Status',
        Align(
          alignment: Alignment.centerLeft,
          child: StatusBadge(status: shipment.status),
        ),
      ),
      ('Direction', Text(shipment.isExport ? 'Export' : 'Import', style: AppTextStyles.fieldValue)),
      ('Sender', Text(shipment.senderName, style: AppTextStyles.fieldValue)),
      ('Receiver', Text(shipment.receiverName, style: AppTextStyles.fieldValue)),
      ('Pick Up From', LocationText(city: shipment.pickupCity, country: shipment.pickupCountry)),
      ('Delivery To', LocationText(city: shipment.deliveryCity, country: shipment.deliveryCountry)),
      ('Amount', Text(formatAmount(shipment.amount), style: AppTextStyles.fieldValue)),
      (
        'Payment',
        Text(shipment.isPaid ? 'Paid' : 'Awaiting payment', style: AppTextStyles.fieldValue),
      ),
      (
        'Processing time',
        Text('${shipment.processingHours} hours', style: AppTextStyles.fieldValue),
      ),
      (
        'Created',
        Text(
          DateFormat('d MMM yyyy, h:mm a').format(shipment.createdAt.toLocal()),
          style: AppTextStyles.fieldValue,
        ),
      ),
    ];

    return SingleChildScrollView(
      child: Column(
        children: [
          for (final (label, value) in rows)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Row(
                children: [
                  SizedBox(width: 130, child: Text(label, style: AppTextStyles.fieldLabel)),
                  Expanded(child: value),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
