import 'package:flutter/material.dart';
import 'package:base_doanh/config/resources/color.dart';

TextStyle textNormal(Color? color, double? fontSize) {
  return TextStyle(
    color: color ?? Colors.white,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    fontSize: fontSize ?? 14,
    fontFamily: TextStyleCustom.fontFamily,
  );
}

TextStyle textNormalCustom(
  Color? color,
  double? fontSize,
  FontWeight? fontWeight,
) {
  return TextStyle(
    color: color,
    fontWeight: fontWeight ?? FontWeight.w400,
    fontSize: fontSize ?? 14,
    fontFamily: TextStyleCustom.fontFamily,
  );
}

class TextStyleCustom {
  TextStyleCustom._();

  static const fontFamily = 'SFUIText';

  /// Regular
  static const textRegular12 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontFamily: fontFamily,
    color: colorBlack85,
  );

  static const textRegular14 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: fontFamily,
    color: colorBlack85,
  );

  ///SemiBold
  static const textSemiBold20 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    fontFamily: fontFamily,
    color: colorBlack85,
  );

  static const textSemiBold14 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    fontFamily: fontFamily,
    color: colorBlack85,
  );

  static const textSemiBold16 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontFamily: fontFamily,
    color: colorBlack85,
  );

  static const buttonSemiBold14 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    fontFamily: fontFamily,
    color: colorBlack85,
  );

  static const buttonSemiBold16 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontFamily: fontFamily,
    color: colorBlack85,
  );

  ///Medium
  static const textMedium14 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontFamily: fontFamily,
    color: colorBlack85,
  );
  static const textMedium16 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    fontFamily: fontFamily,
    color: colorBlack85,
  );
}
