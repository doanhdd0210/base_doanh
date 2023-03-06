import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:base_doanh/config/resources/color.dart';
import 'package:base_doanh/config/themes/app_theme.dart';

class AppButton extends StatelessWidget {
  final double width;
  final double height;
  final VoidCallback? onPressed;
  final dynamic text;
  final Color? backgroundColor;
  final double borderRadius;
  final Color textColor;
  final double textSize;
  final EdgeInsets btnPadding;
  final EdgeInsets btnMargin;
  final TextStyle? textStyle;
  final bool singleLine;
  final Color? borderColor;
  final double borderWidth;

  const AppButton(
    this.text,
    this.onPressed, {
    Key? key,
    this.width = double.infinity,
    this.height = 40.0,
    this.backgroundColor,
    this.borderRadius = 5,
    this.textColor = Colors.white,
    this.textSize = 14.0,
    this.btnPadding = EdgeInsets.zero,
    this.btnMargin = EdgeInsets.zero,
    this.textStyle,
    this.singleLine = false,
    this.borderWidth = 1,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color color =
        backgroundColor ?? AppTheme.getInstance().primaryColor();
    final Color btnColor = onPressed != null ? color : colorDivider;
    return Container(
      width: width,
      height: height,
      margin: btnMargin,
      child: ElevatedButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(btnPadding),
          backgroundColor: MaterialStateProperty.all(btnColor),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              side: BorderSide(
                color: borderColor ?? btnColor,
                width: borderWidth,
              ),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          elevation: MaterialStateProperty.all(0.0),
        ),
        onPressed: onPressed,
        child: Center(
          child: (text is Widget)
              ? (text as Widget)
              : Container(
                  alignment: Alignment.center,
                  child: Text(
                    text.toString(),
                    textAlign: TextAlign.center,
                    style: textStyle ??
                        GoogleFonts.roboto(
                          fontSize: textSize,
                          color: textColor,
                          fontWeight: FontWeight.w700,
                        ),
                    maxLines: singleLine ? 1 : null,
                  ),
                ),
        ),
      ),
    );
  }
}
