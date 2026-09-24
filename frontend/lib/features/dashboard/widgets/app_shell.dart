import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/breakpoints.dart';
import '../nav_destinations.dart';
import 'page_header.dart';
import 'sidebar.dart';

/// Signed-in layout: fixed sidebar on desktop, drawer below 1024px.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.location, required this.child});

  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final destination = destinationFor(location);
    final isDesktop = ScreenSize.of(context).isDesktop;

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: isDesktop
          ? null
          : Drawer(
              width: AppSpacing.sidebarWidth,
              shape: const RoundedRectangleBorder(),
              backgroundColor: AppColors.surface,
              child: Builder(
                builder: (context) => Sidebar(
                  location: location,
                  onNavigate: () => Navigator.of(context).pop(),
                ),
              ),
            ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isDesktop) Sidebar(location: location),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Builder(
                  builder: (context) => PageHeader(
                    title: destination.title,
                    subtitle: destination.subtitle,
                    onMenuTap: isDesktop ? null : () => Scaffold.of(context).openDrawer(),
                  ),
                ),
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
