import 'package:get/get.dart';

bool isAndroid() => GetPlatform.isAndroid;

bool isIOS() => GetPlatform.isIOS;

void finish() => Get.back();

void finishWithResult(dynamic data) => Get.back(result: data);
