import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:base_doanh/domain/locals/prefs_service.dart';

Future<void> launchUrlMy(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    throw 'Could not launch $url';
  }
}

void updateLocale() {
  Get.updateLocale(
    Locale.fromSubtags(languageCode: PrefsService.getLanguage()),
  );
}

void closeKey() {
  FocusManager.instance.primaryFocus?.unfocus();
}
