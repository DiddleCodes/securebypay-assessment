import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../nav_destinations.dart';

class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({super.key, required this.destination});

  final NavDestination destination;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(color: AppColors.surface, shape: BoxShape.circle),
              child: Icon(destination.icon, size: 28, color: AppColors.primary),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('${destination.label} is coming soon', style: AppTextStyles.pageTitle),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'This section is not part of the demo yet.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
            ),
            const SizedBox(height: AppSpacing.xl),
            OutlinedButton.icon(
              onPressed: () => context.go(navDestinations.first.path),
              icon: const Icon(LucideIcons.layoutDashboard, size: 18),
              label: const Text('Back to dashboard'),
            ),
          ],
        ),
      ),
    );
  }
}
