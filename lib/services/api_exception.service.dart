import 'package:dio/dio.dart';

/// Custom API Exception class for handling errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException({required this.message, this.statusCode, this.data});

  @override
  String toString() => message;
}

/// Utility class for handling API errors
class ApiErrorHandler {
  static ApiException handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return ApiException(
            message:
                'Connection timeout. Please check your internet connection and try again.',
            statusCode: null,
          );

        case DioExceptionType.badResponse:
          return _handleBadResponse(error.response);

        case DioExceptionType.cancel:
          return ApiException(
            message: 'Request was cancelled',
            statusCode: null,
          );

        case DioExceptionType.connectionError:
          return ApiException(
            message:
                'No internet connection. Please check your connection and try again.',
            statusCode: null,
          );

        case DioExceptionType.unknown:
          return ApiException(
            message: 'An unexpected error occurred. Please try again.',
            statusCode: null,
          );

        default:
          return ApiException(
            message: 'An unexpected error occurred. Please try again.',
            statusCode: null,
          );
      }
    } else {
      return ApiException(message: error.toString(), statusCode: null);
    }
  }

  static ApiException _handleBadResponse(Response? response) {
    final statusCode = response?.statusCode;
    final data = response?.data;

    // Try to extract error message from response
    String message = 'An error occurred';

    if (data is Map<String, dynamic>) {
      message = data['message'] ?? data['error'] ?? data['msg'] ?? message;
    } else if (data is String) {
      message = data;
    }

    switch (statusCode) {
      case 400:
        return ApiException(
          message: message.isNotEmpty
              ? message
              : 'Bad request. Please check your input.',
          statusCode: statusCode,
          data: data,
        );

      case 401:
        return ApiException(
          message: 'Unauthorized. Please login again.',
          statusCode: statusCode,
          data: data,
        );

      case 403:
        return ApiException(
          message:
              'Access forbidden. You don\'t have permission to access this resource.',
          statusCode: statusCode,
          data: data,
        );

      case 404:
        return ApiException(
          message: 'Resource not found.',
          statusCode: statusCode,
          data: data,
        );

      case 422:
        return ApiException(
          message: message.isNotEmpty
              ? message
              : 'Validation error. Please check your input.',
          statusCode: statusCode,
          data: data,
        );

      case 500:
        return ApiException(
          message: 'Internal server error. Please try again later.',
          statusCode: statusCode,
          data: data,
        );

      case 502:
        return ApiException(
          message: 'Bad gateway. Please try again later.',
          statusCode: statusCode,
          data: data,
        );

      case 503:
        return ApiException(
          message: 'Service unavailable. Please try again later.',
          statusCode: statusCode,
          data: data,
        );

      default:
        return ApiException(
          message: message.isNotEmpty
              ? message
              : 'An error occurred. Please try again.',
          statusCode: statusCode,
          data: data,
        );
    }
  }
}
