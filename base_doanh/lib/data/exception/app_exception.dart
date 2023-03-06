import 'package:base_doanh/generated/l10n.dart';

class AppException implements Exception {
  String title;
  String message;

  AppException(this.title, this.message);

  @override
  String toString() => '$title $message';
}

class CommonException extends AppException {
  CommonException() : super(S.current.error, S.current.something_went_wrong);
}

class NoNetworkException extends AppException {
  NoNetworkException() : super(S.current.error, S.current.error_network);
}

class MaintenanceException extends AppException {
  MaintenanceException() : super(S.current.error, S.current.server_error);
}

class ApiDataException extends AppException {
  String title;
  String message;
  String code;
  String error;
  int statusCode;

  ApiDataException({
    this.title = '',
    this.message = '',
    this.code = '',
    this.error = '',
    this.statusCode = -1,
  }) : super(title, message);

  factory ApiDataException.fromJson(Map<String, dynamic> json) {
    try {
      return ApiDataException(
        statusCode: json['statusCode'] as int? ?? 0,
        code: json['code'] as String? ?? '',
        error: json['error'] as String? ?? '',
        message: json['message'] as String? ?? '',
        title: json['error'] as String? ?? '',
      );
    } catch (e) {
      return ApiDataException(
        title: S.current.error,
        message: S.current.something_went_wrong,
      );
    }
  }
}
