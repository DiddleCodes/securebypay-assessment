import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !isLoading;
    final radius = BorderRadius.circular(AppRadius.md);

    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      excludeSemantics: true,
      child: Opacity(
        opacity: onPressed == null ? 0.6 : 1,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(color: AppColors.primary),
            // Thin darker bands at the top and bottom edges give the design's inset look
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.buttonEdgeTop,
                AppColors.primaryLight,
                AppColors.primary,
                AppColors.buttonEdgeBottom,
              ],
              stops: [0, 0.04, 0.95, 1],
            ),
            boxShadow: const [
              BoxShadow(color: AppColors.buttonShadow, offset: Offset(0, 2), blurRadius: 2),
            ],
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: enabled ? onPressed : null,
              borderRadius: radius,
              child: SizedBox(
                height: AppSpacing.buttonHeight - 2,
                width: expand ? double.infinity : null,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Center(
                    widthFactor: 1,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Keeps the label's width while loading so the button doesn't resize
                        Opacity(
                          opacity: isLoading ? 0 : 1,
                          child: Text(label, style: AppTextStyles.button),
                        ),
                        if (isLoading)
                          const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.onBrand,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
