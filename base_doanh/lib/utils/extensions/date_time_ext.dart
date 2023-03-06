import 'package:intl/intl.dart';
import 'package:base_doanh/utils/constants/app_constants.dart';

extension DateTimeExt on DateTime {
  String convertToString({String pattern = DateTimeFormat.CORAL_DATE_FORMAT}) {
    try {
      return DateFormat(pattern).format(this);
    } catch (_) {
      return '';
    }
  }
}
