import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:base_doanh/config/resources/images.dart';

class ImageAssets {
  //png
  // static String backgroundHeaderPng = '$baseImg/header.png';
  // static const String splash_background = '$baseImg/background_splash.png';
  static const String imgEmpty = '$baseImg/img_empty.png';

  //svg
  // static String icTicket = '$baseImg/ic_ticket.svg';
  // static String icTabTrungChuyen = '$baseImg/ic_tab_trung_chuyen.svg';
  // static String icTabGiaoVe = '$baseImg/ic_tab_giao_ve.svg';
  // static const String icSuccess = '$baseIcon/icSuccess.svg';
  // static const String icSuccess = '$baseIcon/icSuccess.svg';
  static String icSuccess = '$baseImg/ic_success.svg';



  /// Screen + icon
  // static const String ic_person = '$baseIcon/ic_person.svg';


  static SvgPicture svgAssets(
    String name, {
    Color? color,
    double? width,
    double? height,
    BoxFit? fit,
    BlendMode? blendMode,
  }) {
    final size = _svgImageSize[name];
    var w = width;
    var h = height;
    if (size != null) {
      w = width ?? size[0];
      h = height ?? size[1];
    }
    return SvgPicture.asset(
      name,
      colorBlendMode: blendMode ?? BlendMode.srcIn,
      color: color,
      width: w,
      height: h,
      fit: fit ?? BoxFit.none,
    );
  }

  static const Map<String, List<double>> _svgImageSize = {};
}


