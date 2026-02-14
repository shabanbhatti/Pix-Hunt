import 'package:dio/dio.dart';

abstract class DioErrorHandler {
  static String handle(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return "Connection timeout. Please try again.";

        case DioExceptionType.sendTimeout:
          return "Request sending timeout.";

        case DioExceptionType.receiveTimeout:
          return "Response timeout from server.";

        case DioExceptionType.badCertificate:
          return "Secure connection failed (SSL issue).";

        case DioExceptionType.cancel:
          return "Request was cancelled.";

        case DioExceptionType.connectionError:
          return "No internet connection.";

        case DioExceptionType.badResponse:
          return _handleStatusCode(
            error.response?.statusCode,
            error.response?.data,
          );

        case DioExceptionType.unknown:
          return "Unexpected error occurred. Please try again.";
      }
    }

    return "Something went wrong";
  }

  static String _handleStatusCode(int? statusCode, dynamic data) {
    switch (statusCode) {
      case 400:
        return data?["message"] ?? "No images found";

      case 401:
        return "Unauthorized. Please login again.";

      case 403:
        return "Access forbidden";

      case 404:
        return "Data not found";

      case 409:
        return "Conflict occurred";

      case 422:
        return data?["message"] ?? "Validation error";

      case 500:
        return "Internal server error";

      case 502:
        return "Bad gateway";

      case 503:
        return "Service unavailable";

      default:
        return "Server error ($statusCode)";
    }
  }
}
