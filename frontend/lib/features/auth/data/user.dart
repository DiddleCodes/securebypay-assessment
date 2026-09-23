class User {
  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneCode,
    required this.phoneNumber,
    required this.walletBalance,
    this.avatarUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as String,
        firstName: json['firstName'] as String,
        lastName: json['lastName'] as String,
        email: json['email'] as String,
        phoneCode: json['phoneCode'] as String,
        phoneNumber: json['phoneNumber'] as String,
        walletBalance: json['walletBalance'] as int,
        avatarUrl: json['avatarUrl'] as String?,
      );

  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneCode;
  final String phoneNumber;
  final int walletBalance;
  final String? avatarUrl;
}
