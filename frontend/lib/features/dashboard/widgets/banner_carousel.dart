import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import 'banner_stripes_painter.dart';

class BannerCarousel extends StatefulWidget {
  const BannerCarousel({super.key});

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  static const _headlines = [
    'KEEP UP WITH YOUR\nBUSINESS NEEDS',
    'SHIP TO OVER 300\nCOUNTRIES',
    'TRACK EVERY\nSHIPMENT LIVE',
  ];
  static const _interval = Duration(seconds: 5);

  final _controller = PageController();
  Timer? _timer;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(_interval, (_) {
      if (!_controller.hasClients) return;
      _controller.animateToPage(
        (_page + 1) % _headlines.length,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void _goTo(int page) {
    _controller.animateToPage(
      page,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final scale = (width / _BannerSlide.designWidth).clamp(0.5, 1.0);
        final height = (_BannerSlide.designHeight * scale).clamp(150.0, _BannerSlide.designHeight);

        return Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: SizedBox(
                height: height,
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _headlines.length,
                  onPageChanged: (page) => setState(() => _page = page),
                  itemBuilder: (context, index) => _BannerSlide(
                    headline: _headlines[index],
                    scale: scale,
                    showImage: width >= 560,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            _Dots(count: _headlines.length, current: _page, onTap: _goTo),
          ],
        );
      },
    );
  }
}

class _BannerSlide extends StatelessWidget {
  const _BannerSlide({required this.headline, required this.scale, required this.showImage});

  static const designWidth = 1141.0;
  static const designHeight = 245.0;
  static const _imageWidth = 294.5;
  static const _imageRight = 22.5;

  final String headline;
  final double scale;
  final bool showImage;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.navy,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const CustomPaint(painter: BannerStripesPainter()),
          if (showImage)
            Positioned(
              right: _imageRight * scale,
              top: 0,
              bottom: 0,
              child: Image.asset(
                'assets/images/banner_globe.png',
                width: _imageWidth * scale,
                fit: BoxFit.contain,
                alignment: Alignment.bottomCenter,
                excludeFromSemantics: true,
              ),
            ),
          Positioned(
            left: 37.5 * scale,
            right: 24,
            bottom: 36.5 * scale,
            child: Text(
              headline,
              style: AppTextStyles.bannerHeadline.copyWith(
                fontSize: 44 * scale,
                letterSpacing: -1.5 * scale,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.current, required this.onTap});

  final int count;
  final int current;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          Semantics(
            button: true,
            selected: i == current,
            label: 'Slide ${i + 1} of $count',
            child: GestureDetector(
              onTap: () => onTap(i),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i == current ? AppColors.navy : AppColors.dotInactive,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
