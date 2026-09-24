import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'app.dart';

void main() {
  usePathUrlStrategy();
  // Sections show their own error with a retry button, so Riverpod's silent auto-retry is disabled
  runApp(ProviderScope(retry: (_, _) => null, child: const App()));
}
