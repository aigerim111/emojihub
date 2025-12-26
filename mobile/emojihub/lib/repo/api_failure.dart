import 'package:dio/dio.dart';

class ApiFailure implements Exception {
  final String message;
  final int? statusCode;

  ApiFailure(this.message, {this.statusCode});

  @override
  String toString() => 'ApiFailure(statusCode=$statusCode, message=$message)';

  static ApiFailure fromDio(DioException e) {
    final code = e.response?.statusCode;
    final msg = e.response?.data?.toString() ?? e.message ?? 'Network error';
    return ApiFailure(msg, statusCode: code);
  }
}
