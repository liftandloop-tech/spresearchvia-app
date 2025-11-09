import 'package:dio/dio.dart';
import 'package:spresearchvia2/core/utils/error_message_handler.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException({required this.message, this.statusCode, this.data});

  @override
  String toString() => message;
}

class ApiErrorHandler {
  static ApiException handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return ApiException(message: 'Connection Timeout', statusCode: null);

        case DioExceptionType.badResponse:
          return _handleBadResponse(error.response);

        case DioExceptionType.cancel:
          return ApiException(message: 'Request Cancelled', statusCode: null);

        case DioExceptionType.connectionError:
          return ApiException(
            message: 'No Internet Connection',
            statusCode: null,
          );

        case DioExceptionType.unknown:
          return ApiException(message: 'Network Error', statusCode: null);

        default:
          return ApiException(
            message: 'Something Went Wrong',
            statusCode: null,
          );
      }
    } else {
      ErrorMessageHandler.logError('API Error', error);
      return ApiException(
        message: ErrorMessageHandler.getUserFriendlyMessage(error),
        statusCode: null,
      );
    }
  }

  static ApiException _handleBadResponse(Response? response) {
    final statusCode = response?.statusCode;
    final data = response?.data;

    String message = 'Error Occurred';

    if (data is Map<String, dynamic>) {
      message = data['message'] ?? data['error'] ?? data['msg'] ?? message;
    } else if (data is String) {
      message = data;
    }

    if (message.length > 50) {
      message = ErrorMessageHandler.getUserFriendlyMessage(message);
    }

    switch (statusCode) {
      case 400:
        if (message.toLowerCase().contains('already exists') ||
            message.toLowerCase().contains('duplicate')) {
          return ApiException(
            message: 'Account Already Exists',
            statusCode: statusCode,
            data: data,
          );
        }
        return ApiException(
          message: message.isNotEmpty ? message : 'Invalid Request',
          statusCode: statusCode,
          data: data,
        );

      case 401:
        return ApiException(
          message: message.isNotEmpty ? message : 'Unauthorized',
          statusCode: statusCode,
          data: data,
        );

      case 403:
        return ApiException(
          message: 'Access Forbidden',
          statusCode: statusCode,
          data: data,
        );

      case 404:
        return ApiException(
          message: message.isNotEmpty ? message : 'Not Found',
          statusCode: statusCode,
          data: data,
        );

      case 409:
        return ApiException(
          message: 'Already Exists',
          statusCode: statusCode,
          data: data,
        );

      case 422:
        return ApiException(
          message: message.isNotEmpty ? message : 'Validation Error',
          statusCode: statusCode,
          data: data,
        );

      case 429:
        return ApiException(
          message: 'Too Many Requests',
          statusCode: statusCode,
          data: data,
        );

      case 500:
        return ApiException(
          message: 'Server Error',
          statusCode: statusCode,
          data: data,
        );

      case 502:
        return ApiException(
          message: 'Service Unavailable',
          statusCode: statusCode,
          data: data,
        );

      case 503:
        return ApiException(
          message: 'Service Unavailable',
          statusCode: statusCode,
          data: data,
        );

      default:
        return ApiException(
          message: message.isNotEmpty ? message : 'Something Went Wrong',
          statusCode: statusCode,
          data: data,
        );
    }
  }
}
