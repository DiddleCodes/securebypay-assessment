import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/breakpoints.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_snack_bar.dart';
import '../../../core/widgets/labeled_field.dart';
import '../../../core/widgets/password_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/text_link.dart';
import '../providers/auth_controller.dart';
import '../widgets/auth_heading.dart';
import '../widgets/auth_layout.dart';
import '../widgets/terms_text.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  Map<String, String> _serverErrors = const {};
  bool _submitting = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _clearServerError(String field) {
    if (_serverErrors.containsKey(field)) {
      setState(() => _serverErrors = {..._serverErrors}..remove(field));
    }
  }

  Future<void> _submit() async {
    if (_submitting) return;
    setState(() => _serverErrors = const {});
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);
    try {
      await ref
          .read(authControllerProvider.notifier)
          .login(email: _email.text.trim(), password: _password.text);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _serverErrors = e.fieldErrors);
      if (e.fieldErrors.isEmpty) showAppSnackBar(context, e.message);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      formTop: 255,
      panelTitle: 'Effortlessly Track Your Shipments from Nigeria!',
      panelBody: 'Monitor your shipments from Nigeria! Enjoy swift delivery and seamless customs '
          'processing',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AuthHeading(
            title: 'Sign in to your account',
            subtitle: 'Log in to Myafrimall to enjoy seamless shipping to over 300 countries right '
                'from Nigeria.. Don’t have an account yet?',
            linkLabel: 'Sign Up',
            onLinkTap: () => context.go(Routes.register),
            maxWidth: 448,
          ),
          const SizedBox(height: AppSpacing.xxl),
          AutofillGroup(
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LabeledField(
                    label: 'Email',
                    child: TextFormField(
                      controller: _email,
                      validator: Validators.email,
                      forceErrorText: _serverErrors['email'],
                      onChanged: (_) => _clearServerError('email'),
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      textInputAction: TextInputAction.next,
                      style: AppTextStyles.input,
                      decoration: const InputDecoration(hintText: 'user@example.com'),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.fieldGap),
                  LabeledField(
                    label: 'Password',
                    child: PasswordField(
                      controller: _password,
                      validator: (value) => Validators.required(value, 'Password'),
                      errorText: _serverErrors['password'],
                      onChanged: (_) => _clearServerError('password'),
                      autofillHints: const [AutofillHints.password],
                      onSubmitted: (_) => _submit(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          TextLink(
            'Forgot Password?',
            onTap: () =>
                showAppSnackBar(context, 'Password reset is not available in this demo.'),
          ),
          const SizedBox(height: 44),
          PrimaryButton(
            label: 'Login',
            onPressed: _submit,
            isLoading: _submitting,
            expand: ScreenSize.of(context).isMobile,
          ),
          const SizedBox(height: 26),
          const TermsText(),
        ],
      ),
    );
  }
}
