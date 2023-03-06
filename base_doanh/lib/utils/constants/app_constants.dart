import 'package:intl/intl.dart';

enum AppMode { LIGHT, DARK }

enum ServerType { DEV, QA, STAGING, PRODUCT }

enum LoadingType { REFRESH, LOAD_MORE }

enum CompleteType { SUCCESS, ERROR }

enum BiometricDeviceType { FACE, FINGERPRINT, NONE, NO_CHECK }

enum PageTransitionType {
  FADE,
  RIGHT_TO_LEFT,
  BOTTOM_TO_TOP,
  RIGHT_TO_LEFT_WITH_FADE,
}

const int THREE_MINUTES = 3;
const int FIVE_MINUTES = 5;
const int TEN_MINUTES = 10;
const int FIFTEEN_MINUTES = 15;

const String FACE = 'face';
const String FINGERPRINT = 'fingerprint';

final formatUSD = NumberFormat('\$###,###,###,###,###.###', 'en_US');
final formatValue = NumberFormat('###,###,###,###,###.###', 'en_US');
final currency = NumberFormat('#,##0.000000', 'en_US');
final currencyOneDecimal = NumberFormat('#,##0.0', 'en_US');
final currencyTwoDecimal = NumberFormat('#,##0.00', 'en_US');

const String CALENDAR_TYPE_DAY = 'Day';
const String CALENDAR_TYPE_MONTH = 'Month';
const String CALENDAR_TYPE_YEAR = 'Year';

const EN_CODE = 'en';
const VI_CODE = 'vi';
const VI_LANG = 'vn';

const EMAIL_REGEX =
    r'^([a-zA-Z][a-zA-Z0-9_\.]{3,})+@[a-zA-Z0-9]{2,}(\.[a-zA-Z0-9]{2,})+$';
const PASSWORD_REGEX = r'^(?=.*?[A-Z]).{8,20}$';
const USERNAME_REGEX = r'^[a-zA-Z0-9_]*$';
const VN_PHONE = r'(84|0[3|5|7|8|9])+([0-9]{8})\b';
const DECIMAL_REGEX = r'([.]*0+)(?!.*\d)';
const DOUBLE_REGEX = r'(^\d*\.?\d{0,6})';
const CHARACTER_REGEX = r'^[a-zA-Z0-9_.-]*$';
const PASSWORD_REGEX_2 =
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,100}$';
const SPACE_CHARACTER = ' ';
//2021-06-18 04:24:27
const _dtFormat1 = 'yyyy-MM-dd HH:mm:ss';
const _dtFormat2 = 'hh:mm a';
const _dtFormat3 = 'dd/MM HH:mm a';
const _dtFormat4 = 'yyyy-MM-dd';
const _dtFormat5 = 'MMM dd, yyyy';
const _dtFormat6 = 'yyyy-MM-ddTHH:mm:ss';
const _dtFormat8 = 'dd MMM - hh:mm';
const _dtFormat7 = 'dd/MM/yyyy';
const _dtFormat9 = 'MMM dd, yyyy HH:mm';
const _dtFormat10 = 'dd MMM, yyyy';
const _dtFormat11 = 'HH:mm dd/MM/yyyy';
const _dtFormat12 = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
const _dtFormat13 = ' HH:mm MMM dd, yyyy';

class DateTimeFormat {
  static const DEFAULT_FORMAT = _dtFormat1;
  static const HOUR_FORMAT = _dtFormat2;
  static const CREATE_FORMAT = _dtFormat3;
  static const DOB_FORMAT = _dtFormat4;
  static const CREATE_BLOG_FORMAT = _dtFormat5;
  static const BE_DATE_FORMAT = _dtFormat6;
  static const CORAL_DATE_FORMAT = _dtFormat7;
  static const SHORT_DATETIME = _dtFormat8;
  static const LONG_DATETIME = _dtFormat9;
  static const LONG_DATE = _dtFormat10;
  static const HM_DATETIME = _dtFormat11;
  static const Z_DATETIME = _dtFormat12;
  static const HM_DATETIME_STRING = _dtFormat13;
}

class FileExtension {
  static const JPG = 'jpg';
  static const JPEG = 'jpeg';
  static const PNG = 'png';
  static const HEIC = 'heic';
}

class FileSize {
  static const SIZE_5_MB = 5000000;
}
