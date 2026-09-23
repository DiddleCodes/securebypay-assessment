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
import '../providers/auth_controller.dart';
import '../widgets/auth_heading.dart';
import '../widgets/auth_layout.dart';
import '../widgets/phone_field.dart';
import '../widgets/terms_text.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  String _phoneCode = PhoneField.countryCodes.first;
  Map<String, String> _serverErrors = const {};
  bool _submitting = false;

  @override
  void dispose() {
    for (final controller in [_firstName, _lastName, _email, _phone, _password]) {
      controller.dispose();
    }
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
      await ref.read(authControllerProvider.notifier).register(
            firstName: _firstName.text.trim(),
            lastName: _lastName.text.trim(),
            email: _email.text.trim(),
            phoneCode: _phoneCode,
            phoneNumber: _phone.text.trim(),
            password: _password.text,
          );
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _serverErrors = e.fieldErrors);
      if (e.fieldErrors.isEmpty) showAppSnackBar(context, e.message);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Widget _textField({
    required String label,
    required String field,
    required TextEditingController controller,
    required String hint,
    required FormFieldValidator<String> validator,
    required Iterable<String> autofillHints,
    TextInputType? keyboardType,
  }) {
    return LabeledField(
      label: label,
      child: TextFormField(
        controller: controller,
        validator: validator,
        forceErrorText: _serverErrors[field],
        onChanged: (_) => _clearServerError(field),
        keyboardType: keyboardType,
        autofillHints: autofillHints,
        textInputAction: TextInputAction.next,
        style: AppTextStyles.input,
        decoration: InputDecoration(hintText: hint),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      formTop: 209,
      panelTitle: 'Seamlessly Delivering to Over 300 Countries from Nigeria!',
      panelBody: 'Access global markets with our quick shipping from Nigeria! Fast delivery and '
          'easy customs to 300+ countries.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AuthHeading(
            title: 'Create an account',
            subtitle: 'Sign up for Myafrimall and gain unlimited access to shipping to over 300 '
                'countries from Nigeria. Do you already have an account?',
            linkLabel: 'Login',
            onLinkTap: () => context.go(Routes.login),
            maxWidth: 468,
          ),
          const SizedBox(height: AppSpacing.xxl),
          AutofillGroup(
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _textField(
                          label: 'First name',
                          field: 'firstName',
                          controller: _firstName,
                          hint: 'John',
                          validator: (value) => Validators.required(value, 'First name'),
                          autofillHints: const [AutofillHints.givenName],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xl),
                      Expanded(
                        child: _textField(
                          label: 'Last name',
                          field: 'lastName',
                          controller: _lastName,
                          hint: 'Doe',
                          validator: (value) => Validators.required(value, 'Last name'),
                          autofillHints: const [AutofillHints.familyName],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.fieldGap),
                  _textField(
                    label: 'Email',
                    field: 'email',
                    controller: _email,
                    hint: 'user@example.com',
                    validator: Validators.email,
                    autofillHints: const [AutofillHints.email],
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: AppSpacing.fieldGap),
                  LabeledField(
                    label: 'Phone Number',
                    child: PhoneField(
                      controller: _phone,
                      countryCode: _phoneCode,
                      onCountryCodeChanged: (code) => setState(() => _phoneCode = code),
                      errorText: _serverErrors['phoneNumber'] ?? _serverErrors['phoneCode'],
                      onChanged: (_) {
                        _clearServerError('phoneNumber');
                        _clearServerError('phoneCode');
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.fieldGap),
                  LabeledField(
                    label: 'Password',
                    child: PasswordField(
                      controller: _password,
                      validator: Validators.newPassword,
                      errorText: _serverErrors['password'],
                      onChanged: (_) => _clearServerError('password'),
                      autofillHints: const [AutofillHints.newPassword],
                      onSubmitted: (_) => _submit(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 42),
          PrimaryButton(
            label: 'Create account',
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
