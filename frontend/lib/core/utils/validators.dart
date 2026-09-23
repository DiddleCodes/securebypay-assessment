abstract final class Validators {
  static final _email = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  static final _digits = RegExp(r'^\d+$');

  static String? required(String? value, String label) =>
      (value == null || value.trim().isEmpty) ? '$label is required' : null;

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    return _email.hasMatch(value.trim()) ? null : 'Enter a valid email address';
  }

  static String? phoneNumber(String? value) {
    final phone = value?.trim() ?? '';
    if (phone.isEmpty) return 'Phone number is required';
    if (!_digits.hasMatch(phone)) return 'Phone number must contain digits only';
    if (phone.length < 7) return 'Phone number is too short';
    if (phone.length > 15) return 'Phone number is too long';
    return null;
  }

  static String? newPassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 8) return 'Password must be at least 8 characters';
    return null;
  }
}
