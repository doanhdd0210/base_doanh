import 'package:get/get.dart';
import 'package:base_doanh/domain/env/develop.dart';
import 'package:base_doanh/domain/env/model/app_constants.dart';
import 'package:base_doanh/main.dart';

Future<void> main() async {
  Get.put(AppConstants.fromJson(configDevEnv));
  await mainApp();
}
