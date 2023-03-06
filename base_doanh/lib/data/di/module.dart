import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' as Foundation;
import 'package:get/get.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:base_doanh/data/di/flutter_transformer.dart';
import 'package:base_doanh/data/network/unauthorized_handle.dart';
import 'package:base_doanh/data/repository_impl/account_repository_impl.dart';
import 'package:base_doanh/data/services/account_service.dart';
import 'package:base_doanh/domain/env/model/app_constants.dart';
import 'package:base_doanh/domain/locals/prefs_service.dart';
import 'package:base_doanh/domain/repository/account_repository.dart';

void configureDependencies() {
  Get.put(AccountClient(provideDio()));
  Get.put<AccountRepository>(AccountRepositoryImpl(Get.find()));
}

int _connectTimeOut = 60000;

Dio provideDio({TypeRepo type = TypeRepo.DEFAULT}) {
  final appConstants = Get.find<AppConstants>();

  final options = BaseOptions(
    baseUrl: type.getBaseUrl(appConstants),
    receiveTimeout: _connectTimeOut,
    connectTimeout: _connectTimeOut,
    followRedirects: false,
  );
  final dio = Dio(options);
  void onReFreshToken(DioError e, ErrorInterceptorHandler handler) {
    HandleUnauthorized.resignRefreshToken(
      onRefreshToken: (token) async {
        if (token.isNotEmpty) {
          options.headers.remove('Authorization');
          options.headers['Authorization'] = 'Bearer $token';
        }
        final opts = Options(
          method: e.requestOptions.method,
          headers: e.requestOptions.headers,
        );
        final cloneReq = await dio.request(
          e.requestOptions.path,
          options: opts,
          data: e.requestOptions.data,
          queryParameters: e.requestOptions.queryParameters,
        );

        return handler.resolve(cloneReq);
      },
      onError: (error) {
        return handler.next(e);
      },
    );
  }

  dio.transformer = FlutterTransformer();
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest:
          (RequestOptions options, RequestInterceptorHandler handler) async {
        final String accessToken = PrefsService.getToken();
        options.baseUrl = type.getBaseUrl(appConstants);
        options.headers['Content-Type'] = 'application/json';
        options.headers['X-Client-Version'] = '1.0';
        options.headers['followRedirects'] = '1.0';
        options.headers['Accept'] = '*/*';
        if (accessToken.isNotEmpty) {
          options.headers.remove('Authorization');
          options.headers['Authorization'] = 'Bearer $accessToken';
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response); // continue
      },
      onError: (DioError e, handler) {
        if (e.response?.statusCode == 401) {
          return onReFreshToken(e, handler);
        } else {
          return handler.next(e);
        }
      },
    ),
  );
  if (Foundation.kDebugMode) {
    dio.interceptors.add(dioLogger());
  }
  return dio;
}

PrettyDioLogger dioLogger() {
  return PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
    maxWidth: 100,
  );
}

enum TypeRepo {
  DEFAULT,
  NEAR,
}

extension TypeRepoExt on TypeRepo {
  String getBaseUrl(AppConstants appConstants) {
    switch (this) {
      case TypeRepo.DEFAULT:
        return appConstants.baseUrl;
      default:
        return appConstants.baseUrl;
    }
  }
}
