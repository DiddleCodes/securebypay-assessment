import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_provider.dart';
import 'user.dart';

typedef AuthSession = ({String token, User user});

final authRepositoryProvider = Provider((ref) => AuthRepository(ref.read(dioProvider)));

class AuthRepository {
  AuthRepository(this._dio);

  final Dio _dio;

  Future<AuthSession> login({required String email, required String password}) =>
      _authenticate('/auth/login', {'email': email, 'password': password});

  Future<AuthSession> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneCode,
    required String phoneNumber,
    required String password,
  }) => _authenticate('/auth/register', {
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'phoneCode': phoneCode,
    'phoneNumber': phoneNumber,
    'password': password,
  });

  Future<User> me() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/auth/me');
      return User.fromJson(response.data!['user'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<AuthSession> _authenticate(String path, Map<String, String> body) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(path, data: body);
      final data = response.data!;
      return (
        token: data['token'] as String,
        user: User.fromJson(data['user'] as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
