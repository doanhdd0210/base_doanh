import 'package:flutter/material.dart';
import 'package:hapycar/config/resources/color.dart';
import 'package:hapycar/config/resources/styles.dart';

import '../../config/themes/app_theme.dart';

enum ButtonSize { SMALL, MEDIUM, LARGE }

enum ButtonState { DEFAULT, DISABLED }

enum ButtonType { PRIMARY, SECONDARY }

class ButtonCustom extends StatelessWidget {
  const ButtonCustom({
    Key? key,
    this.text,
    required this.onPressed,
    this.leftIcon,
    this.rightIcon,
    this.size = ButtonSize.MEDIUM,
    this.state = ButtonState.DEFAULT,
    this.type = ButtonType.PRIMARY,
    this.background = colorPrimary,
    this.defaultBorderColor,
    this.autoResize = false,
    this.borderLineWidth = 1,
    this.removePaddings = false,
    this.elevation = 2,
    this.horizontalAlignment = MainAxisAlignment.center,
    this.textColor,
    this.padding,
    this.isHide = false,
    this.textStyle,
  }) : super(key: key);

  final String? text;
  final TextStyle? textStyle;
  final GestureTapCallback onPressed;
  final Widget? leftIcon;
  final Widget? rightIcon;
  final ButtonSize size;
  final ButtonState state;
  final ButtonType type;
  final Color background;
  final Color? textColor;
  final Color? defaultBorderColor;
  final bool autoResize;
  final bool isHide;
  final double borderLineWidth;
  final bool removePaddings;
  final double elevation;
  final EdgeInsetsGeometry? padding;
  final MainAxisAlignment horizontalAlignment;

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];

    if (leftIcon != null) {
      children.add(Padding(
        padding: EdgeInsets.only(
          right: removePaddings
              ? 0
              : text != null
                  ? (size == ButtonSize.LARGE
                      ? 18
                      : size == ButtonSize.MEDIUM
                          ? 14
                          : 9)
                  : rightIcon != null
                      ? (size == ButtonSize.SMALL ? 5 : 10)
                      : 0,
        ),
        child: leftIcon!,
      ));
    }

    if (text != null) {
      children.add(Expanded(
        child: Center(
          child: Text(
            text!,
            style: textStyle ??
                (size == ButtonSize.SMALL
                        ? TextStyleCustom.f14w600
                        : size == ButtonSize.LARGE
                            ? TextStyleCustom.f18w600
                            : TextStyleCustom.f16w600)
                    .apply(
                        color: textColor ??
                            (type == ButtonType.PRIMARY
                                ? AppTheme.getInstance().whiteColor()
                                : AppTheme.getInstance().primaryColor())),
          ),
        ),
      ));
    }

    if (rightIcon != null) {
      children.add(Padding(
        padding: EdgeInsets.only(
          left: removePaddings
              ? 0
              : text != null
                  ? (size == ButtonSize.LARGE
                      ? 18
                      : size == ButtonSize.MEDIUM
                          ? 14
                          : 9)
                  : leftIcon != null
                      ? (size == ButtonSize.SMALL ? 5 : 10)
                      : 0,
        ),
        child: rightIcon!,
      ));
    }

    return Padding(
      padding: padding ?? const EdgeInsets.all(0),
      child: RawMaterialButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        elevation: isHide ? 0 : elevation,
        focusElevation: 2,
        highlightElevation: 0,
        hoverElevation: 0,
        fillColor: isHide
            ? AppTheme.getInstance().grayColor()
            : type == ButtonType.PRIMARY
                ? background
                : background != colorPrimary
                    ? background
                    : AppTheme.getInstance().whiteColor(),
        constraints: const BoxConstraints(),
        onPressed: () {
          if (!isHide) {
            FocusManager.instance.primaryFocus?.unfocus();
            onPressed();
          }
        },
        shape: RoundedRectangleBorder(
          side: type == ButtonType.PRIMARY
              ? BorderSide.none
              : BorderSide(
                  color: defaultBorderColor ??
                      AppTheme.getInstance().primaryColor(),
                  width: borderLineWidth),
          borderRadius: BorderRadius.all(
            Radius.circular(size == ButtonSize.SMALL ? 6 : 8),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              removePaddings
                  ? 0
                  : (leftIcon != null
                      ? (size == ButtonSize.LARGE
                          ? 24
                          : size == ButtonSize.MEDIUM
                              ? 16
                              : 8)
                      : (size == ButtonSize.LARGE
                          ? 24
                          : (size == ButtonSize.SMALL && text == null
                              ? 8
                              : 16))),
              removePaddings ? 0 : (size == ButtonSize.SMALL ? 13 : 16),
              removePaddings
                  ? 0
                  : (rightIcon != null
                      ? (size == ButtonSize.LARGE
                          ? 24
                          : size == ButtonSize.MEDIUM
                              ? 16
                              : 8)
                      : (size == ButtonSize.LARGE
                          ? 24
                          : (size == ButtonSize.SMALL && text == null
                              ? 8
                              : 16))),
              removePaddings ? 0 : (size == ButtonSize.SMALL ? 13 : 16)),
          child: Row(
            mainAxisSize: autoResize ? MainAxisSize.min : MainAxisSize.max,
            mainAxisAlignment: horizontalAlignment,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          ),
        ),
      ),
    );
  }
}
