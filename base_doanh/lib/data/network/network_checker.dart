// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class CheckerNetwork {
  static const String GOOGLE_URL = 'https://www.google.com/';
  static const int STATUS_CODE_SUCCESS = 200;

  static Future<bool> checkNetwork() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  static Future<bool> checkNetworkByGoogle() async {
    try {
      final http.Response response = await http
          .get(Uri.parse(GOOGLE_URL))
          .timeout(const Duration(seconds: 3));
      if (response.statusCode == STATUS_CODE_SUCCESS) {
        return true;
      } else {
        return false;
      }
    } on TimeoutException {
      return false;
    } on SocketException {
      return false;
    }
  }
}
