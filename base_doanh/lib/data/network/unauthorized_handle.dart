import 'package:get/get.dart';
import 'package:base_doanh/config/base/root_screen.dart';
import 'package:base_doanh/data/exception/app_exception.dart';
import 'package:base_doanh/data/result/result.dart';
import 'package:base_doanh/domain/locals/prefs_service.dart';
import 'package:base_doanh/domain/model/authenication/unauthorized_model.dart';
import 'package:base_doanh/domain/repository/account_repository.dart';

class HandleUnauthorized {
  static final List<_ResultRefreshTokenCallBack> _callBackUnauthorized = [];

  static void resignRefreshToken({
    required Function(String) onRefreshToken,
    required Function(AppException) onError,
  }) {
    if (_callBackUnauthorized.isEmpty) {
      _handleUnauthorized().then((value) {
        value.when(
          success: (res) {
            PrefsService.saveToken(res.accessToken);
            PrefsService.saveRefreshToken(
              res.refreshToken,
            );
            for (final element in _callBackUnauthorized) {
              element.onRefreshToken.call(res.accessToken);
            }
            _callBackUnauthorized.clear();
          },
          error: (error) {
            for (final element in _callBackUnauthorized) {
              element.onError.call(error);
            }
            _callBackUnauthorized.clear();
            RootScreenScreen.showDialogLoginByExpiredToken();
          },
        );
      });
    }
    _callBackUnauthorized
        .add(_ResultRefreshTokenCallBack(onRefreshToken, onError));
  }

  static Future<Result<UnauthorizedModel>> _handleUnauthorized() async {
    final AccountRepository loginRepo = Get.find();

    return loginRepo.refreshToken(
      PrefsService.getRefreshToken(),
    );
  }
}

class _ResultRefreshTokenCallBack {
  final Function(String) onRefreshToken;
  final Function(AppException) onError;

  _ResultRefreshTokenCallBack(this.onRefreshToken, this.onError);
}
