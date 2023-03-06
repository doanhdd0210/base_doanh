import 'package:intl/intl.dart';
import 'package:base_doanh/utils/constants/app_constants.dart';

extension NumberExt on num {
  String formatToCurrency({NumberFormat? format}) {
    try {
      final formatter = format ?? currency;
      return formatter.format(this).replaceAll(RegExp(DECIMAL_REGEX), '');
    } catch (e) {
      return '0';
    }
  }

  String numberLikeFormat() {
    if (this < 1000) {
      return toString();
    }
    if (this >= 1000 && this < 1000000) {
      final front = this ~/ 1000;
      final end = (this % 1000) ~/ 100;
      return '$front${end > 0 ? ',$end' : ''}';
    } else {
      final front = this ~/ 1000000;
      final end = (this % 1000000) ~/ 100000;
      return '$front${end > 0 ? ',$end' : ''}';
    }
  }



  String millisecondToMinute() {
    if (this == 0) {
      return '0s';
    }
    final int sec = ((this / 1000) % 60).toInt();
    final int min = ((this / (1000 * 60)) % 60).toInt();
    final int hour = ((this / (1000 * 60 * 60)) % 24).toInt();

    final String minute = min.toString();
    final String second = sec.toString().length <= 1 ? '0$sec' : '$sec';
    if (hour > 0) {
      return '${hour}h${minute}m${second}s';
    }
    if (min > 0) {
      return '${minute}m${second}s';
    }
    return '${second}s';
  }
}
