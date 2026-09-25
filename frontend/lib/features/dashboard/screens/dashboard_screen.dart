import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/breakpoints.dart';
import '../widgets/banner_carousel.dart';
import '../widgets/overview_section.dart';
import '../widgets/recent_shipments_section.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gutter = ScreenSize.of(context).isMobile ? AppSpacing.lg : AppSpacing.contentGutter;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(gutter, 19, gutter, AppSpacing.contentGutter),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BannerCarousel(),
          SizedBox(height: 30),
          OverviewSection(),
          SizedBox(height: 39),
          RecentShipmentsSection(),
        ],
      ),
    );
  }
}
