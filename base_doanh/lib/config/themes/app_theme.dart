import 'package:base_doanh/config/app_config.dart';
import 'package:base_doanh/config/resources/color.dart';
import 'package:base_doanh/utils/constants/app_constants.dart';

class AppTheme {
  static AppColor? _instance;

  static AppColor getInstance() {
    _instance ??= AppMode.LIGHT == APP_THEME ? LightTheme() : DarkTheme();
    return _instance!;
  }
}
