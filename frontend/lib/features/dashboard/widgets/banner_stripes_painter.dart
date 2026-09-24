import 'dart:math' as math;

import 'package:flutter/rendering.dart';

import '../../../core/theme/app_colors.dart';

/// Low-contrast diagonal bands matching the banner artwork: -22.7deg, irregular widths.
class BannerStripesPainter extends CustomPainter {
  const BannerStripesPainter();

  static const _angle = -22.7 * math.pi / 180;

  // Alternating band and gap widths, repeated; irregular so the pattern doesn't look mechanical
  static const _pattern = [14.0, 9.0, 4.0, 18.0, 22.0, 6.0, 3.0, 12.0, 9.0, 26.0, 5.0, 8.0];

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.bannerStripe;
    final diagonal = size.width + size.height;

    canvas
      ..save()
      ..translate(size.width / 2, size.height / 2)
      ..rotate(_angle);

    var y = -diagonal / 2;
    var i = 0;
    while (y < diagonal / 2) {
      final band = _pattern[i % _pattern.length];
      final gap = _pattern[(i + 5) % _pattern.length];
      canvas.drawRect(Rect.fromLTWH(-diagonal / 2, y, diagonal, band), paint);
      y += band + gap;
      i++;
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(BannerStripesPainter oldDelegate) => false;
}
