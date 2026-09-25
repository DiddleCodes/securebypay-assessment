import 'package:flutter/material.dart';

import '../../../core/theme/app_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/validators.dart';

class PhoneField extends StatelessWidget {
  const PhoneField({
    super.key,
    required this.controller,
    required this.countryCode,
    required this.onCountryCodeChanged,
    this.errorText,
    this.onChanged,
  });

  static const countryCodes = ['+234', '+233', '+254', '+27', '+44', '+1'];

  final TextEditingController controller;
  final String countryCode;
  final ValueChanged<String> onCountryCodeChanged;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: Validators.phoneNumber,
      forceErrorText: errorText,
      onChanged: onChanged,
      keyboardType: TextInputType.phone,
      autofillHints: const [AutofillHints.telephoneNumberNational],
      textInputAction: TextInputAction.next,
      style: AppTextStyles.input,
      decoration: InputDecoration(
        hintText: '8012345678',
        prefixIconConstraints: const BoxConstraints(),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: AppSpacing.lg, right: 2),
          child: PopupMenuButton<String>(
            tooltip: 'Country code',
            initialValue: countryCode,
            onSelected: onCountryCodeChanged,
            position: PopupMenuPosition.under,
            itemBuilder: (context) => [
              for (final code in countryCodes)
                PopupMenuItem(
                  value: code,
                  child: Text(code, style: AppTextStyles.bodySmall),
                ),
            ],
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ValueListenableBuilder(
                  valueListenable: controller,
                  builder: (context, value, _) => Text(
                    countryCode,
                    style: AppTextStyles.input.copyWith(
                      color: value.text.isEmpty ? AppColors.textPlaceholder : AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 3),
                const Icon(AppIcons.chevronDown, size: 20, color: AppColors.icon),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
