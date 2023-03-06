import 'package:dartx/dartx.dart';
import 'package:intl/intl.dart';
import 'package:base_doanh/generated/l10n.dart';
import 'package:base_doanh/utils/constants/app_constants.dart';

extension FormatAddressFire on String {
  String formatAddressActivityFire() {
    try {
      final String result = '${substring(0, 5)}...${substring(
        length - 5,
        length,
      )}';
      return result;
    } catch (e) {
      return '';
    }
  }

  String convertNameFile() {
    final document = this;

    final parts = document.split('/');

    final lastName = parts.last;

    final partsNameFile = lastName.split('.');

    if (partsNameFile[0].length > 30) {
      partsNameFile[0] = '${partsNameFile[0].substring(0, 10)}... ';
    }
    final fileName = '${partsNameFile[0]}.${partsNameFile[1]}';

    return fileName;
  }

  DateTime convertStringToDate({String formatPattern = 'yyyy-MM-dd'}) {
    try {
      return DateFormat(formatPattern).parse(this);
    } catch (_) {
      return DateTime.now();
    }
  }

  String changeDatetimePattern(
      {String oldPattern = DateTimeFormat.BE_DATE_FORMAT,
      String newPattern = DateTimeFormat.CORAL_DATE_FORMAT,
      bool toLocal = true}) {
    try {
      return toLocal
          ? DateFormat(newPattern)
              .format(DateFormat(oldPattern).parse(this, true).toLocal())
          : DateFormat(newPattern).format(DateFormat(oldPattern).parse(this));
    } catch (_) {
      return '';
    }
  }

  DateTime? getDateTime({
    String pattern = DateTimeFormat.BE_DATE_FORMAT,
  }) {
    try {
      return DateFormat(pattern).parse(this, true).toLocal();
    } catch (_) {
      return null;
    }
  }
}

extension StringValidate on String {
  String? isNormalCharacter({required String errorMessage}) {
    if (!matches(RegExp(CHARACTER_REGEX))) {
      return errorMessage;
    }
    return null;
  }

  String? checkRequired({required String fieldName}) {
    if (isNullOrEmpty) {
      return '$fieldName ${S.current.ok}';
    }
    return null;
  }

  // String? validatePassword() {
  //   if (!matches(RegExp(PASSWORD_REGEX_2))) {
  //     return S.current.invalid_passcode;
  //   }
  //   return null;
  // }
  //
  // String? validatePasswordConfirm({required String password}) {
  //   if (this != password) {
  //     return S.current.confirm_passcode_did_not_match;
  //   }
  //   return null;
  // }
}

extension DateTimeExt on String {
  String changeToNewPatternDate({
    String oldPattern = DateTimeFormat.BE_DATE_FORMAT,
    required String newPattern,
    bool toLocal = true,
  }) {
    try {
      if (toLocal) {
        return DateFormat(newPattern, 'en').format(
          DateFormat(oldPattern).parse(this, true).toLocal(),
        );
      } else {
        return DateFormat(
          newPattern,
        ).format(
          DateFormat(oldPattern).parse(this),
        );
      }
    } catch (_) {
      return '';
    }
  }
}
