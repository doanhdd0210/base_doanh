import 'package:base_doanh/utils/constants/app_constants.dart';

extension BiometricExtention on BiometricDeviceType {
  String getName() {
    switch (this) {
      case BiometricDeviceType.FACE:
        return FACE;
      case BiometricDeviceType.FINGERPRINT:
        return FINGERPRINT;
      default:
        return '';
    }
  }
}

extension EnumOnStringExt on String {
  BiometricDeviceType getTypeBiometric() {
    switch (this) {
      case FACE:
        return BiometricDeviceType.FACE;
      case FINGERPRINT:
        return BiometricDeviceType.FINGERPRINT;
      default:
        return BiometricDeviceType.NONE;
    }
  }


}

