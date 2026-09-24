import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/currency.dart';
import '../../../core/widgets/app_snack_bar.dart';
import '../../../core/widgets/labeled_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../providers/wallet_actions.dart';

Future<void> showFundWalletDialog(BuildContext context) {
  return showDialog(context: context, builder: (_) => const _FundWalletDialog());
}

class _FundWalletDialog extends ConsumerStatefulWidget {
  const _FundWalletDialog();

  @override
  ConsumerState<_FundWalletDialog> createState() => _FundWalletDialogState();
}

class _FundWalletDialogState extends ConsumerState<_FundWalletDialog> {
  static const _maxKobo = 100000000;

  final _formKey = GlobalKey<FormState>();
  final _amount = TextEditingController();
  bool _submitting = false;
  String? _serverError;

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  int? _parseKobo(String text) {
    final naira = double.tryParse(text.replaceAll(',', '').trim());
    return naira == null ? null : (naira * 100).round();
  }

  String? _validate(String? value) {
    final kobo = _parseKobo(value ?? '');
    if (kobo == null) return 'Enter an amount';
    if (kobo < 100) return 'The minimum top-up is N1';
    if (kobo > _maxKobo) return 'The maximum top-up is ${formatBalance(_maxKobo)}';
    return null;
  }

  Future<void> _submit() async {
    setState(() => _serverError = null);
    if (!_formKey.currentState!.validate()) return;

    final kobo = _parseKobo(_amount.text)!;
    setState(() => _submitting = true);
    try {
      await ref.read(walletActionsProvider).fund(kobo);
      if (!mounted) return;
      Navigator.of(context).pop();
      showAppSnackBar(context, '${formatBalance(kobo)} added to your wallet');
    } on ApiException catch (e) {
      if (mounted) setState(() => _serverError = e.fieldErrors['amount'] ?? e.message);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Fund Wallet', style: AppTextStyles.pageTitle),
      contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Top up your wallet to pay for shipments.', style: AppTextStyles.authSubtitle),
              const SizedBox(height: AppSpacing.xl),
              LabeledField(
                label: 'Amount (N)',
                child: TextFormField(
                  controller: _amount,
                  autofocus: true,
                  validator: _validate,
                  forceErrorText: _serverError,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
                  onFieldSubmitted: (_) => _submit(),
                  style: AppTextStyles.input,
                  decoration: const InputDecoration(hintText: '5000'),
                ),
              ),
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.all(AppSpacing.xl),
      actions: [
        TextButton(
          onPressed: _submitting ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        PrimaryButton(label: 'Fund Wallet', onPressed: _submit, isLoading: _submitting),
      ],
    );
  }
}
