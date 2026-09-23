import 'package:flutter/widgets.dart';

enum ScreenSize {
  mobile,
  tablet,
  desktop;

  static const tabletMin = 600.0;
  static const desktopMin = 1024.0;

  static ScreenSize of(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= desktopMin) return desktop;
    if (width >= tabletMin) return tablet;
    return mobile;
  }

  bool get isDesktop => this == desktop;
  bool get isMobile => this == mobile;
}
