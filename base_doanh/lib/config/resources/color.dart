import 'dart:ui';

import 'package:flutter/material.dart';

///=========== Colors for default when didn't setup app theme ===============
///https://stackoverflow.com/a/17239853
///

///design system
const Color colorBackground = Color(0xffffffff);
const Color colorPrimary = Color(0xffE24648);
const Color colorSuccess = Color(0xff1AC888);
const Color colorWarning = Color(0xffF7AF22);
const Color colorError = Color(0xffF4541D);
const Color colorBlue = Color(0xff2E81FF);
const Color colorNote = Color(0xffFEF7E9);
const Color colorBorder = Color(0xffd9d9d9);
const Color colorDivider = Color(0xfff5f5f5);
const Color colorDisable = Color(0xffbfbfbf);

///Text
const Color colorTextTitle = Color(0xff262626);
const Color colorTextPrimary = Color(0xff595959);
const Color colorTextSecondary = Color(0xff8c8c8c);

const Color colorBlack85 = Color(0xff262626);
const Color colorBlack65 = Color(0xff595959);
const Color colorBlack45 = Color(0xff8c8c8c);
const Color colorBlack15 = Color(0xffd9d9d9);
const Color colorBlack4 = Color(0xffF5F5F5);

const CLBB202D = Color(0xffee535f);
const CL28C76F = Color(0xff253e8c);
const CL8D0712 = Color(0xffec3343);
const CLE8EFFA = Color(0xffE8EFFA);
const CL0ABAB5 = Color(0xA324EA5C);
const CLDCFFFE = Color(0xff06bff8);
const CLE0F2F1 = Color(0xFFE0F2F1);
const CL30536F = Color(0xFF30536F);
const CL303742 = Color(0xFFEC2C3B);
const CL808FA8 = Color(0xFFAF7958);
const CL8F9CAE = Color(0xff8F9CAE);
const CL24272B = Color(0xff2464b7);
const CLFFF1F2 = Color(0xffFFF1F2);
const CL000000 = Color(0xff000000);
const CLBDCFE = Color(0xffBDCFE8);
const CLF7FAFD = Color(0xffF7FAFD);
const CLF5F6F8 = Color(0xFFF5F6F8);
const CLBAC4D3 = Color(0xFFBAC4D3);
const CLFFBEC3 = Color(0xffFFBEC3);
const CL6B81A0 = Color(0xFF6B81A0);
const CLDBDFEF = Color(0xffDBDFEF);

//bottom navigation color
const CLFCFCFC = Color(0xFFFCFCFC);
const CL8E9CB0 = Color(0xFF8E9CB0);
const CLFFFFFF = Color(0xFFFFFFFF);
const CLF2F7FC = Color(0xFFF2F7FC);
const CL6589CF = Color(0xFF6589CF);
const Cl929EB0 = Color(0xFF929EB0);

//custom color
const CLC9D7E0 = Color(0xFFC9D7E0);
const CL96589CF = Color(0x296589CF);
const CL2BCB6B = Color(0xFF2BCB6B);
const CL929EB0 = Color(0xFF929EB0);
const CL27A9FF = Color(0xff06bff8);

///buttonTextColor
const CLFF7F22 = Color(0xFFFF7F22);

const CLEEF8FF = Color(0xFFEEF8FF);
const CLFFEBDC = Color(0xFFFFEBDC);
const CLFEDCDE = Color(0xFFFEDCDE);
const CLFFA755 = Color(0xFFEDDFA1);
const listColor = [CLFFA755, CLFFBEC3, CL6589CF, CL0ABAB5, CLFF7F22, CL0ABAB5];
const yellowColor = Color(0xffFDB000);
const pinkColor = Color(0xffFB7897);
const blueHole = Color(0xff5A8DEE);
const purple = Color(0xff7966FF);
const Color color13BC78 = Color(0xff13BC78);
const Color color2BCB6B = Color(0xff2BCB6B);
const Color colorA9ACC1 = Color(0xffA9ACC1);
const Color color717294 = Color(0xff717294);
const Color color433F63 = Color(0xff433F63);
const Color colorFAFAFA = Color(0xffFAFAFA);
const Color color234A6D = Color(0xff234A6D);
const Color colorFEEAEA = Color(0xffFEEAEA);
const Color colorE72D2D = Color(0xffE72D2D);
const Color colorF65354 = Color(0xffF65354);
const Color colorF0EEEE = Color(0xffF0EEEE);
const Color color5875AC = Color(0xff5875AC);
const Color colorF0FDF6 = Color(0xffF0FDF6);
const Color colorFFA755 = Color(0xffFFA755);
const Color colorAFBCFF = Color(0xffAFBCFF);
const Color color3779F5 = Color(0xff3779F5);
const Color color1EE9B6 = Color(0xff1EE9B6);
const Color colorFAF2FF = Color(0xffFAF2FF);
const Color color8E30C9 = Color(0xff8E30C9);
const Color colorEDF9FF = Color(0xffEDF9FF);
const Color color12A3F4 = Color(0xff12A3F4);
const Color colorFFFAED = Color(0xffFFFAED);
const Color colorF44912 = Color(0xffF44912);
const Color colorFFF1F1 = Color(0xffFFF1F1);
const Color colorFF0FDF6 = Color(0xffF0FDF6);
const Color colorF4B922 = Color(0xffF4B922);
const Color color7A89FE = Color(0xff7A89FE);
const Color colorFF4267 = Color(0xffFF4267);

///=========== Using to make change app theme ================================
abstract class AppColor {
  Color primaryColor();

  Color backgroundPrimary();

  Color getLineColor();

  Color accentColor();

  Color getTextWhiteColor();

  Color statusColor();

  Color dfTxtColor();

  Color whiteTextColor();

  Color dfBtnColor();

  Color dfBtnTxtColor();

  Color backgroundColor();

  Color subTitleColor();

  Color unSelectedColor();

  Color selectedColor();

  Color greyButtonColor();

  Color shadowColor();

  Color disableUnderlineColor();

  Color hintTextColors();

  Color dividerColor();

  Color greyTextColor();

  Color hintTextColor();

  Color darkRed();

  Color leafPrimaryColor();

  Color getBlackText();

  List<Color> colors();

  Color borderColor();
}

class LightTheme extends AppColor {
  @override
  Color accentColor() {
    return CL28C76F;
  }

  @override
  Color backgroundColor() {
    return colorBackground;
  }

  @override
  Color dfBtnColor() {
    throw UnimplementedError();
  }

  @override
  Color dfBtnTxtColor() {
    return CLBB202D;
  }

  @override
  Color dfTxtColor() {
    return CL27A9FF;
  }

  @override
  Color primaryColor() {
    return colorPrimary;
  }

  @override
  Color getLineColor() {
    return CLBDCFE;
  }

  @override
  Color statusColor() {
    throw UnimplementedError();
  }

  @override
  Color subTitleColor() {
    throw UnimplementedError();
  }

  @override
  Color unSelectedColor() {
    return CL8E9CB0;
  }

  @override
  Color selectedColor() {
    return CLF2F7FC;
  }

  @override
  Color getTextWhiteColor() {
    return CLE8EFFA;
  }

  @override
  Color backgroundPrimary() {
    return CLC9D7E0;
  }

  @override
  Color whiteTextColor() {
    return CLFFF1F2;
  }

  @override
  Color greyButtonColor() {
    return CLF5F6F8;
  }

  @override
  Color shadowColor() {
    return CL96589CF;
  }

  @override
  Color disableUnderlineColor() {
    return CLC9D7E0;
  }

  @override
  Color hintTextColors() {
    return CLBAC4D3;
  }

  @override
  Color dividerColor() {
    return colorDivider;
  }

  @override
  Color greyTextColor() {
    return CLFFF1F2;
  }

  @override
  Color hintTextColor() {
    return Cl929EB0;
  }

  @override
  Color darkRed() {
    return CL8D0712;
  }

  @override
  Color leafPrimaryColor() {
    return CLFFA755;
  }

  @override
  List<Color> colors() {
    // TODO: implement colors
    return listColor;
  }

  @override
  Color getBlackText() {
    return CL000000;
  }

  @override
  Color borderColor() {
    return colorBorder;
  }
}

class DarkTheme extends AppColor {
  @override
  Color whiteTextColor() {
    return CLFFF1F2;
  }

  @override
  Color getTextWhiteColor() {
    return CL000000;
  }

  @override
  Color backgroundPrimary() {
    return CLC9D7E0;
  }

  @override
  Color accentColor() {
    return CL28C76F;
  }

  @override
  Color getLineColor() {
    return CLBDCFE;
  }

  @override
  Color backgroundColor() {
    return CLFFFFFF;
  }

  @override
  Color dfBtnColor() {
    throw UnimplementedError();
  }

  @override
  Color dfBtnTxtColor() {
    return CL27A9FF;
  }

  @override
  Color dfTxtColor() {
    return CL27A9FF;
  }

  @override
  Color primaryColor() {
    return blueHole;
  }

  @override
  Color statusColor() {
    throw UnimplementedError();
  }

  @override
  Color subTitleColor() {
    throw UnimplementedError();
  }

  @override
  Color unSelectedColor() {
    return CL8E9CB0;
  }

  @override
  Color selectedColor() {
    // TODO: implement selectedColor
    throw UnimplementedError();
  }

  @override
  Color greyButtonColor() {
    // TODO: implement buttonGreyColor
    throw UnimplementedError();
  }

  @override
  Color dividerColor() {
    // TODO: implement dividerColor
    return CLC9D7E0;
  }

  @override
  Color greyTextColor() {
    // TODO: implement greyTextColor
    throw UnimplementedError();
  }

  @override
  Color shadowColor() {
    return CL96589CF;
  }

  @override
  Color disableUnderlineColor() {
    // TODO: implement disableUnderlineColor
    throw UnimplementedError();
  }

  @override
  Color hintTextColors() {
    return CLBAC4D3;
  }

  @override
  Color hintTextColor() {
    return Cl929EB0;
  }

  @override
  Color darkRed() {
    return CL8D0712;
  }

  @override
  Color leafPrimaryColor() {
    return CLFFA755;
  }

  @override
  List<Color> colors() {
    return listColor;
  }

  @override
  Color getBlackText() {
    return CL000000;
  }

  @override
  Color borderColor() {
    return CLDBDFEF;
  }
}

///============ End setup app theme ======================================
