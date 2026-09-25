import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_icons.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_button_styles.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/breakpoints.dart';
import '../../../core/utils/currency.dart';
import '../../../core/widgets/app_snack_bar.dart';
import '../data/shipment.dart';
import '../providers/wallet_actions.dart';
import 'location_text.dart';
import 'shipment_details_dialog.dart';
import 'status_badge.dart';

class ShipmentCard extends StatefulWidget {
  const ShipmentCard({super.key, required this.shipment, this.initiallyExpanded = false});

  final Shipment shipment;
  final bool initiallyExpanded;

  @override
  State<ShipmentCard> createState() => _ShipmentCardState();
}

class _ShipmentCardState extends State<ShipmentCard> {
  late bool _expanded = widget.initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final shipment = widget.shipment;
    final mobile = ScreenSize.of(context).isMobile;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      padding: EdgeInsets.symmetric(horizontal: mobile ? AppSpacing.lg : AppSpacing.xl),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.topCenter,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Summary(
              shipment: shipment,
              expanded: _expanded,
              mobile: mobile,
              onToggle: () => setState(() => _expanded = !_expanded),
            ),
            if (_expanded) ...[
              const Divider(height: 1, color: AppColors.border),
              _Route(shipment: shipment, mobile: mobile),
              const Divider(height: 1, color: AppColors.border),
              _Footer(shipment: shipment, mobile: mobile),
            ],
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.label, required this.child, this.gap = 6});

  final String label;
  final Widget child;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: AppTextStyles.fieldLabel),
        SizedBox(height: gap),
        child,
      ],
    );
  }
}

class _TwoColumnWrap extends StatelessWidget {
  const _TwoColumnWrap({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = (constraints.maxWidth - AppSpacing.lg) / 2;
        return Wrap(
          spacing: AppSpacing.lg,
          runSpacing: AppSpacing.lg,
          children: [for (final child in children) SizedBox(width: width, child: child)],
        );
      },
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({
    required this.shipment,
    required this.expanded,
    required this.mobile,
    required this.onToggle,
  });

  final Shipment shipment;
  final bool expanded;
  final bool mobile;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    Text value(String text, [Color? color]) => Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyles.fieldValue.copyWith(color: color),
    );

    final tracking = _Field(
      label: 'Tracking ID',
      child: value(shipment.trackingId, AppColors.primary),
    );
    final sender = _Field(label: 'Sender', child: value(shipment.senderName));
    final receiver = _Field(label: 'Receiver', child: value(shipment.receiverName));

    return InkWell(
      onTap: onToggle,
      child: Padding(
        padding: EdgeInsets.only(
          top: AppSpacing.xl,
          bottom: expanded ? AppSpacing.lg : AppSpacing.xl,
        ),
        child: Row(
          children: [
            Expanded(
              child: mobile
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        tracking,
                        const SizedBox(height: AppSpacing.lg),
                        _TwoColumnWrap(children: [sender, receiver]),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(flex: 272, child: tracking),
                        Expanded(flex: 205, child: sender),
                        Expanded(flex: 592, child: receiver),
                      ],
                    ),
            ),
            Semantics(
              button: true,
              label: expanded ? 'Collapse shipment' : 'Expand shipment',
              child: AnimatedRotation(
                turns: expanded ? 0 : 0.5,
                duration: const Duration(milliseconds: 200),
                child: const Icon(AppIcons.chevronUp, size: 24, color: AppColors.chevron),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Route extends StatelessWidget {
  const _Route({required this.shipment, required this.mobile});

  final Shipment shipment;
  final bool mobile;

  @override
  Widget build(BuildContext context) {
    final pickup = _Field(
      label: 'Pick Up From',
      gap: 5,
      child: LocationText(city: shipment.pickupCity, country: shipment.pickupCountry),
    );
    final delivery = _Field(
      label: 'Delivery To',
      gap: 5,
      child: LocationText(city: shipment.deliveryCity, country: shipment.deliveryCountry),
    );
    final amount = _Field(
      label: 'Amount',
      gap: 5,
      child: Text(formatAmount(shipment.amount), style: AppTextStyles.fieldValue),
    );
    final status = _Field(
      label: 'Status',
      gap: AppSpacing.sm,
      child: StatusBadge(status: shipment.status),
    );

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xl, bottom: 23),
      child: mobile
          ? _TwoColumnWrap(children: [pickup, delivery, amount, status])
          : Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(child: pickup),
                Expanded(child: delivery),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(child: amount),
                      status,
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _Footer extends ConsumerStatefulWidget {
  const _Footer({required this.shipment, required this.mobile});

  final Shipment shipment;
  final bool mobile;

  @override
  ConsumerState<_Footer> createState() => _FooterState();
}

class _FooterState extends ConsumerState<_Footer> {
  bool _paying = false;

  Future<void> _pay() async {
    final shipment = widget.shipment;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Pay for shipment', style: AppTextStyles.pageTitle),
        content: Text(
          'Pay ${formatAmount(shipment.amount)} for ${shipment.trackingId} from your wallet balance?',
          style: AppTextStyles.bodySmall,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.navy),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Pay Now'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _paying = true);
    try {
      await ref.read(walletActionsProvider).pay(shipment.trackingId);
      if (mounted) showAppSnackBar(context, 'Payment successful for ${shipment.trackingId}');
    } on ApiException catch (e) {
      if (mounted) showAppSnackBar(context, e.message);
    } finally {
      if (mounted) setState(() => _paying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final shipment = widget.shipment;
    final mobile = widget.mobile;

    final processing = _Field(
      label: 'Processing time',
      gap: AppSpacing.sm,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(AppIcons.timer, size: 24, color: AppColors.textBody),
          const SizedBox(width: AppSpacing.sm),
          Text('${shipment.processingHours} hours', style: AppTextStyles.fieldValue),
        ],
      ),
    );

    final viewMore = OutlinedButton(
      style: AppButtonStyles.cardOutlined.copyWith(
        fixedSize: mobile ? const WidgetStatePropertyAll(Size.fromHeight(40)) : null,
      ),
      onPressed: () => showShipmentDetailsDialog(context, shipment.trackingId),
      child: const Text('View More'),
    );
    final payment = FilledButton(
      style: AppButtonStyles.cardFilled.copyWith(
        fixedSize: mobile ? const WidgetStatePropertyAll(Size.fromHeight(40)) : null,
      ),
      onPressed: shipment.isPaid || _paying ? null : _pay,
      child: _paying
          ? const SizedBox.square(
              dimension: 14,
              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.paidText),
            )
          : Text(shipment.isPaid ? 'Paid' : 'Pay Now'),
    );

    return Padding(
      padding: const EdgeInsets.only(top: 26, bottom: 26),
      child: mobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                processing,
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(child: viewMore),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(child: payment),
                  ],
                ),
              ],
            )
          : Row(
              children: [
                Expanded(child: processing),
                viewMore,
                const SizedBox(width: AppSpacing.sm),
                payment,
              ],
            ),
    );
  }
}
