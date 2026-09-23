import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(onPressed: () => context.go(Routes.login), child: const Text('Login')),
      ),
    );
  }
}
