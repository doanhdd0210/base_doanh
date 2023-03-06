import 'package:flutter/material.dart';
import 'package:base_doanh/config/resources/color.dart';
import 'package:base_doanh/config/resources/styles.dart';

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
    this.foregroundColor = Colors.white,
    this.defaultBorderColor = colorBorder,
    this.autoResize = false,
    this.borderLineWidth = 1,
    this.removePaddings = false,
    this.horizontalAlignment = MainAxisAlignment.center,
  }) : super(key: key);

  final String? text;
  final GestureTapCallback onPressed;
  final Widget? leftIcon;
  final Widget? rightIcon;
  final ButtonSize size;
  final ButtonState state;
  final ButtonType type;
  final Color background;
  final Color foregroundColor;
  final Color defaultBorderColor;
  final bool autoResize;
  final double borderLineWidth;
  final bool removePaddings;
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
      children.add(Text(
        text!,
        style: (size == ButtonSize.SMALL
            ? TextStyleCustom.buttonSemiBold14
            : size == ButtonSize.SMALL
            ? TextStyleCustom.buttonSemiBold14
            : TextStyleCustom.buttonSemiBold16)
            .apply(color: foregroundColor),
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

    return RawMaterialButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      elevation: 0,
      focusElevation: 2,
      highlightElevation: 0,
      hoverElevation: 0,
      fillColor: background,
      constraints: const BoxConstraints(),
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
          side: type == ButtonType.PRIMARY
              ? BorderSide.none
              : BorderSide(color: defaultBorderColor, width: borderLineWidth),
          borderRadius: BorderRadius.all(
              Radius.circular(size == ButtonSize.SMALL ? 24 : 32))),
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
            removePaddings ? 0 : (size == ButtonSize.SMALL ? 8 : 16),
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
            removePaddings ? 0 : (size == ButtonSize.SMALL ? 8 : 16)),
        child: Row(
          mainAxisSize: autoResize ? MainAxisSize.min : MainAxisSize.max,
          mainAxisAlignment: horizontalAlignment,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: children,
        ),
      ),
    );
  }
}
