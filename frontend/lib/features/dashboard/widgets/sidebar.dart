import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../auth/providers/auth_controller.dart';
import '../nav_destinations.dart';
import 'sidebar_item.dart';

class Sidebar extends ConsumerWidget {
  const Sidebar({super.key, required this.location, this.onNavigate});

  final String location;

  /// Called after a destination is chosen, e.g. to close the drawer.
  final VoidCallback? onNavigate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = destinationFor(location);
    final user = ref.watch(authControllerProvider).value;

    void go(String path) {
      onNavigate?.call();
      context.go(path);
    }

    return Container(
      width: AppSpacing.sidebarWidth,
      color: AppColors.surface,
      // Painted over the content so the border doesn't narrow the layout and shift items off-centre
      foregroundDecoration: const BoxDecoration(
        border: Border(right: BorderSide(color: AppColors.border)),
      ),
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                // Empty brand strip lining up with the page header, as in the design; pointless in a drawer
                if (onNavigate == null)
                  Container(
                    height: AppSpacing.headerHeight,
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: AppColors.border)),
                    ),
                  ),
                const SizedBox(height: 38),
                for (final destination in navDestinations) ...[
                  SidebarItem(
                    icon: destination.icon,
                    label: destination.label,
                    selected: destination == current,
                    onTap: () => go(destination.path),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
                const Spacer(),
                const SizedBox(height: AppSpacing.xl),
                if (user != null) _UserSummary(firstName: user.firstName, lastName: user.lastName),
                const SizedBox(height: AppSpacing.xl),
                SidebarItem(
                  icon: AppIcons.logOut,
                  label: 'Logout',
                  onTap: () => ref.read(authControllerProvider.notifier).logout(),
                ),
                const SizedBox(height: 31),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UserSummary extends StatelessWidget {
  const _UserSummary({required this.firstName, required this.lastName});

  final String firstName;
  final String lastName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SidebarItem.width,
      child: Padding(
        padding: const EdgeInsets.only(left: AppSpacing.lg),
        child: Row(
          children: [
            const CircleAvatar(radius: 24, backgroundImage: AssetImage('assets/images/avatar.png')),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                '$firstName\n$lastName',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.userName,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
