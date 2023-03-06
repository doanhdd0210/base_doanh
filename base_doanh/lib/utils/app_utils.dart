import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:share_plus/share_plus.dart';
import 'package:base_doanh/domain/env/model/app_constants.dart';
import 'package:base_doanh/utils/constants/app_constants.dart';
import 'package:base_doanh/widgets/dialog/cupertino_loading.dart';

void hideKeyboard(BuildContext context) {
  FocusScope.of(context).requestFocus(FocusNode());
}

bool isEmail(String email) {
  return RegExp(EMAIL_REGEX).hasMatch(email);
}

bool isUserName(String userName) {
  return RegExp(USERNAME_REGEX).hasMatch(userName);
}

bool isPassword(String password) {
  return RegExp(PASSWORD_REGEX).hasMatch(password);
}

/// validate vietnam phone number
bool isVNPhone(String phone) {
  return RegExp(VN_PHONE).hasMatch(phone);
}

double getWithSize(BuildContext context) {
  final Size size = MediaQuery.of(context).size;
  return size.width;
}

double getHeightSize(BuildContext context) {
  final Size size = MediaQuery.of(context).size;
  return size.height;
}

// Future<String> getDeviceName() async {
//   if (Platform.isAndroid) {
//     final androidInfo = await DeviceInfoPlugin().androidInfo;
//     //Xiaomi Redmi Note 7
//     return '${androidInfo.manufacturer} ${androidInfo.model}';
//   }
//
//   if (Platform.isIOS) {
//     final iosInfo = await DeviceInfoPlugin().iosInfo;
//     //iPhone 11 Pro Max iPhone
//     return '${iosInfo.name} ${iosInfo.model}';
//   }
//   return '';
// }

// Future<String> getOSName() async {
//   if (Platform.isAndroid) {
//     final info = await DeviceInfoPlugin().androidInfo;
//     // Android 9 (SDK 28)
//     return 'Android ${info.version.release} (SDK ${info.version.sdkInt})';
//   }
//
//   if (Platform.isIOS) {
//     final iosInfo = await DeviceInfoPlugin().iosInfo;
//     // iOS 13.1, iPhone 11 Pro Max iPhone
//     return '${iosInfo.systemName}, ${iosInfo.systemVersion}';
//   }
//   return '';
// }

Future<int> getAndroidOSVersion() async {
  if (Platform.isAndroid) {
    final info = await DeviceInfoPlugin().androidInfo;
    // Android 9 (SDK 28)
    return info.version.sdkInt;
  }
  return -1;
}

String getDevice() {
  if (Platform.isAndroid) {
    return 'android';
  } else if (Platform.isIOS) {
    return 'ios';
  }
  return 'others';
}

// Future<String> getAppVersion() async {
//   final PackageInfo packageInfo = await PackageInfo.fromPlatform();
//   return packageInfo.version;
// }
//
// Future<String> getDeviceId() async {
//   final deviceInfo = DeviceInfoPlugin();
//   if (Platform.isIOS) {
//     final iosDeviceInfo = await deviceInfo.iosInfo;
//     return iosDeviceInfo.identifierForVendor;
//   } else if (Platform.isAndroid) {
//     final androidDeviceInfo = await deviceInfo.androidInfo;
//     return androidDeviceInfo.androidId;
//   } else {
//     return '';
//   }
// }

void showLoading(BuildContext context, {Function? close}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      return WillPopScope(
        child: const Center(
          child: CupertinoLoading(),
        ),
        onWillPop: () async => false,
      );
    },
  ).then(
    (value) {
      if (close != null) close(value);
    },
  );
}

void hideLoading(BuildContext context) {
  Navigator.of(context).pop();
}

void shareLink({
  String text = '',
  Map<String, dynamic>? dynamicParams,
  required BuildContext context,
}) {
  final box = context.findRenderObject() as RenderBox?;
  Share.share(
    text,
    subject: Get.find<AppConstants>().appName,
    sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
  );
}

Future<bool> uploadToSignedUrl({
  required File file,
  required String signedUrl,
}) async {
  try {
    final Uri uri = Uri.parse(signedUrl.split('?').first);
    await put(
      uri,
      body: await file.readAsBytes(),
    ).timeout(const Duration(milliseconds: 60000));
    return true;
  } catch (e) {
    return false;
  }
}
