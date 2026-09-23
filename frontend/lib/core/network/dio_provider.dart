import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/providers/auth_controller.dart';
import 'auth_interceptor.dart';
import 'token_storage.dart';

const apiBaseUrl = String.fromEnvironment('API_URL', defaultValue: 'http://localhost:4000/api');

final dioProvider = Provider<Dio>((ref) {
  // Generous timeouts: the free Render instance can take ~50s to wake from sleep
  final dio = Dio(BaseOptions(
    baseUrl: apiBaseUrl,
    connectTimeout: const Duration(seconds: 60),
    receiveTimeout: const Duration(seconds: 60),
    contentType: Headers.jsonContentType,
  ));

  dio.interceptors.add(AuthInterceptor(
    ref.read(tokenStorageProvider),
    onUnauthorized: () => ref.read(authControllerProvider.notifier).sessionExpired(),
  ));
  return dio;
});
