import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/providers/auth_controller.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).value;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Signed in as ${user?.firstName} ${user?.lastName}'),
            TextButton(
              onPressed: () => ref.read(authControllerProvider.notifier).logout(),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
