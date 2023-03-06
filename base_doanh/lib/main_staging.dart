import 'package:get/get.dart';
import 'package:base_doanh/domain/env/model/app_constants.dart';
import 'package:base_doanh/domain/env/staging.dart';
import 'package:base_doanh/main.dart';

Future<void> main() async {
  Get.put(AppConstants.fromJson(configStagEnvironment));
  await mainApp();
}
