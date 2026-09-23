import 'package:dio/dio.dart';

class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode, this.fieldErrors = const {}});

  factory ApiException.fromDio(DioException error) {
    final data = error.response?.data;
    if (data is Map<String, dynamic> && data['message'] is String) {
      final errors = data['errors'];
      return ApiException(
        data['message'] as String,
        statusCode: error.response?.statusCode,
        fieldErrors: errors is Map
            ? errors.map((key, value) => MapEntry(key.toString(), value.toString()))
            : const {},
      );
    }

    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.sendTimeout =>
        const ApiException('The server took too long to respond. Please try again.'),
      DioExceptionType.connectionError =>
        const ApiException("Can't reach the server. Check your connection and try again."),
      _ => ApiException(
          'Something went wrong. Please try again.',
          statusCode: error.response?.statusCode,
        ),
    };
  }

  final String message;
  final int? statusCode;
  final Map<String, String> fieldErrors;

  @override
  String toString() => message;
}
