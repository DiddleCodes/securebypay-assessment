import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/breakpoints.dart';
import 'auth_panel.dart';

/// Split auth page from the 1440x1024 design: a 700px form column and the map panel.
class AuthLayout extends StatelessWidget {
  const AuthLayout({
    super.key,
    required this.formTop,
    required this.panelTitle,
    required this.panelBody,
    required this.child,
  });

  static const _designHeight = 1024.0;
  static const _panelWidth = 740.0;
  static const _formColumnWidth = 700.0;
  static const _minFormColumnWidth = 664.0;
  static const _formRightSpace = 64.0;
  static const formWidth = 536.0;

  /// Distance from the top of the page to the form at the design height.
  final double formTop;
  final String panelTitle;
  final String panelBody;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final screen = ScreenSize.of(context);
    final size = MediaQuery.sizeOf(context);

    if (screen.isDesktop) {
      // Below 1440 the form column gives up space first so the panel copy isn't squeezed
      final columnWidth = (size.width - _panelWidth).clamp(_minFormColumnWidth, _formColumnWidth);
      final formLeft = columnWidth - formWidth - _formRightSpace;
      // Scale the top offset down on shorter windows so the form stays in view
      final top = (formTop * size.height / _designHeight).clamp(48.0, formTop);
      return Scaffold(
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: columnWidth,
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(formLeft, top, _formRightSpace, 48),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(width: formWidth, child: child),
                ),
              ),
            ),
            Expanded(child: AuthPanel(title: panelTitle, body: panelBody)),
          ],
        ),
      );
    }

    final gutter = screen.isMobile ? AppSpacing.mobileGutter : 48.0;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: gutter, vertical: 48),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight - 96),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: formWidth),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
