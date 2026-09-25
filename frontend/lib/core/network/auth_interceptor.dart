import 'package:dio/dio.dart';

import 'token_storage.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokenStorage, {required this.onUnauthorized});

  static const _credentialPaths = {'/auth/login', '/auth/register'};

  final TokenStorage _tokenStorage;
  final void Function() onUnauthorized;

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _tokenStorage.read();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401 && !_credentialPaths.contains(err.requestOptions.path)) {
      onUnauthorized();
    }
    handler.next(err);
  }
}
