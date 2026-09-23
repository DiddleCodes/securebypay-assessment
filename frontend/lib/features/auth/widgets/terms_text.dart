import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_snack_bar.dart';

class TermsText extends StatefulWidget {
  const TermsText({super.key});

  @override
  State<TermsText> createState() => _TermsTextState();
}

// Uses recognizers rather than TextLink so "privacy policy" can wrap mid-link like the design
class _TermsTextState extends State<TermsText> {
  late final _privacy = TapGestureRecognizer()..onTap = _notAvailable;
  late final _terms = TapGestureRecognizer()..onTap = _notAvailable;

  void _notAvailable() => showAppSnackBar(context, 'Legal pages are not available in this demo.');

  @override
  void dispose() {
    _privacy.dispose();
    _terms.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 390),
      child: Text.rich(
        TextSpan(
          style: AppTextStyles.authSubtitle,
          children: [
            const TextSpan(text: 'By clicking on create account you agree to our '),
            TextSpan(
              text: 'privacy policy',
              style: AppTextStyles.link,
              recognizer: _privacy,
              mouseCursor: SystemMouseCursors.click,
            ),
            const TextSpan(text: ' and '),
            TextSpan(
              text: 'terms of use',
              style: AppTextStyles.link,
              recognizer: _terms,
              mouseCursor: SystemMouseCursors.click,
            ),
          ],
        ),
      ),
    );
  }
}
