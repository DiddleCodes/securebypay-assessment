import 'package:flutter/material.dart';

import '../theme/app_icons.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required this.controller,
    this.validator,
    this.errorText,
    this.autofillHints,
    this.onSubmitted,
    this.onChanged,
  });

  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final String? errorText;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscured = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscured,
      validator: widget.validator,
      forceErrorText: widget.errorText,
      autofillHints: widget.autofillHints,
      onFieldSubmitted: widget.onSubmitted,
      onChanged: widget.onChanged,
      textInputAction: TextInputAction.done,
      style: AppTextStyles.input,
      decoration: InputDecoration(
        hintText: 'Enter Password',
        suffixIconConstraints: const BoxConstraints(),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: AppSpacing.lg),
          child: IconButton(
            onPressed: () => setState(() => _obscured = !_obscured),
            tooltip: _obscured ? 'Show password' : 'Hide password',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            style: IconButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
            icon: Icon(_obscured ? AppIcons.eyeOff : AppIcons.eye, size: 24, color: AppColors.icon),
          ),
        ),
      ),
    );
  }
}
