import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class AuthPanel extends StatelessWidget {
  const AuthPanel({super.key, required this.title, required this.body});

  static const _mapWidth = 740.0;
  static const _mapHeight = 879.0;

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.primary,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          // OverflowBox keeps the map at its native size, anchored top-left, clipped when the panel is smaller
          Positioned.fill(
            child: OverflowBox(
              alignment: Alignment.topLeft,
              minWidth: _mapWidth,
              maxWidth: _mapWidth,
              minHeight: _mapHeight,
              maxHeight: _mapHeight,
              child: Image.asset(
                'assets/images/world_map.png',
                width: _mapWidth,
                height: _mapHeight,
                excludeFromSemantics: true,
              ),
            ),
          ),
          Positioned.fill(
            child: CustomSingleChildLayout(
              delegate: _PanelCopyLayout(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Text(title, style: AppTextStyles.panelHeadline),
                  ),
                  const SizedBox(height: 16),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 575),
                    child: Text(body, style: AppTextStyles.panelBody),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Places the copy 720px down as in the design, lifting it on short windows so it never runs off the bottom.
class _PanelCopyLayout extends SingleChildLayoutDelegate {
  static const _left = 70.0;
  static const _top = 720.0;
  static const _minEdge = 48.0;
  static const _bottomSpace = 64.0;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      BoxConstraints(maxWidth: math.max(0, constraints.maxWidth - _left * 2));

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final top = math.min(_top, size.height - childSize.height - _bottomSpace);
    return Offset(_left, math.max(_minEdge, top));
  }

  @override
  bool shouldRelayout(_PanelCopyLayout oldDelegate) => false;
}
