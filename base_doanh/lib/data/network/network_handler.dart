// ignore_for_file: depend_on_referenced_packages

import 'package:dio/dio.dart';
import 'package:base_doanh/data/exception/app_exception.dart';
import 'package:base_doanh/generated/l10n.dart';

class NetworkHandler {
  static AppException handleError(DioError error) {
    return _handleError(error);
  }

  static AppException _handleError(error) {
    if (error is! DioError) {
      return AppException(S.current.error, S.current.something_went_wrong);
    }
    if (_isNetWorkError(error)) {
      return NoNetworkException();
    }
    final parsedException = _parseError(error);
    final errorCode = error.response?.statusCode;
    if (errorCode != null && errorCode ~/ 500 > 0) {
      return MaintenanceException();
    }
    return parsedException;
  }

  static bool _isNetWorkError(DioError error) {
    final errorType = error.type;
    switch (errorType) {
      case DioErrorType.cancel:
        return true;
      case DioErrorType.connectTimeout:
        return true;
      case DioErrorType.receiveTimeout:
        return true;
      case DioErrorType.sendTimeout:
        return true;
      case DioErrorType.response:
        return false;
      default:
        return false;
    }
  }

  static AppException _parseError(DioError error) {
    if (error.response?.data is! Map<String, dynamic>) {
      return AppException(S.current.error, S.current.something_went_wrong);
    } else {
      return ApiDataException.fromJson(error.response?.data);
    }
  }
}
