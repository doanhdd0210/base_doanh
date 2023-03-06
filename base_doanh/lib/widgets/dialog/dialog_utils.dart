import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:base_doanh/config/resources/color.dart';
import 'package:base_doanh/config/resources/styles.dart';
import 'package:base_doanh/config/themes/app_theme.dart';
import 'package:base_doanh/utils/get_ext.dart';
import 'package:base_doanh/utils/style_utils.dart';
import 'package:base_doanh/widgets/button/button_custom.dart';
import 'package:base_doanh/widgets/dialog/android_dialog_widget.dart';
import 'package:base_doanh/widgets/dialog/cupertino_loading.dart';
import 'package:base_doanh/widgets/dialog/ios_dialog_widget.dart';

class DialogUtils {
  static void showAlert({
    bool cancelable = false,
    @required String? content,
    String? title,
    TextStyle? titleStyle,
    TextStyle? contentStyle,
    String? ok,
    String? cancel,
    Function? onConfirm,
    Function? onCancel,
  }) {
    if (Get.isDialogOpen == true) return;
    Get.dialog(
      isAndroid()
          ? AndroidDialog(
              onWillPop: cancelable,
              content: content,
              title: title,
              titleStyle: titleStyle,
              contentStyle: contentStyle,
              ok: ok,
              cancel: cancel,
              onConfirm: onConfirm,
              onCancel: onCancel,
            )
          : IOSDialog(
              content: content,
              title: title,
              titleStyle: titleStyle,
              contentStyle: contentStyle,
              ok: ok,
              cancel: cancel,
              onConfirm: onConfirm,
              onCancel: onCancel,
            ),
      barrierDismissible: cancelable,
    );
  }

  static void showLoading() {
    Get.dialog(
      WillPopScope(
        child: const Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          child: Center(child: CupertinoLoading()),
        ),
        onWillPop: () async => false,
      ),
      barrierDismissible: false,
    );
  }

  static void hideLoading() {
    if (Get.isDialogOpen == true) Get.back();
  }

  static void dismiss() {
    if (Get.isDialogOpen == true) Get.back();
  }

  static void showCoralDialog({
    TextAlign? titleAlign,
    String? title,
    required String content,
    Widget? contentWidget,
    Widget? titleWidget,
    bool barrierDismissible = true,
    String? positive,
    String? negative,
    Function()? positiveClick,
    Function()? negativeClick,
    Function()? onClose,
  }) {
    if (Get.isDialogOpen == true) return;
    Get.dialog(
      Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: const SizedBox.shrink(),
            ),
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  if (barrierDismissible) {
                    Get.back();
                  }
                },
              ),
            ),
            Center(
              child: Container(
                constraints: BoxConstraints(
                  maxHeight:
                      MediaQueryData.fromWindow(WidgetsBinding.instance.window)
                              .size
                              .height *
                          0.7,
                ),
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: AppTheme.getInstance().backgroundColor(),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (titleWidget != null) ...[
                      titleWidget,
                      spaceH40,
                    ],
                    if (title != null) ...[
                      Text(
                        title,
                        style: TextStyleCustom.textSemiBold16,
                        textAlign: TextAlign.center,
                      ),
                      spaceH24,
                    ],
                    SizedBox(
                      child: Text(
                        content,
                        style: TextStyleCustom.textRegular12,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    if (contentWidget != null) contentWidget,
                    if (positive != null || negative != null) ...[
                      spaceH40,
                      Row(
                        children: [
                          if (negative != null)
                            Expanded(
                              child: ButtonCustom(
                                text: negative,
                                onPressed: negativeClick ?? () {},
                                background:
                                AppTheme.getInstance().primaryColor(),
                                foregroundColor:
                                colorBlack85,
                              ),
                            ),
                          if (negative != null && positive != null) spaceW8,
                          if (positive != null)
                            Expanded(
                              child: ButtonCustom(
                                text: positive,
                                onPressed: positiveClick ?? () {},
                              ),
                            ),
                        ],
                      )
                    ]
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ).then((_) {
      onClose?.call();
    });
  }

  static Future<void> showCoralDialogAndAwait({
    TextAlign? titleAlign,
    String? title,
    required String content,
    Widget? contentWidget,
    Widget? titleWidget,
    bool barrierDismissible = true,
    String? positive,
    String? negative,
    Function()? positiveClick,
    Function()? negativeClick,
    Function()? onClose,
  }) async {
    if (Get.isDialogOpen == true) return;
    await Get.dialog(
      Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: const SizedBox.shrink(),
            ),
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  if (barrierDismissible) {
                    Get.back();
                  }
                },
              ),
            ),
            Center(
              child: Container(
                constraints: BoxConstraints(
                  maxHeight:
                      MediaQueryData.fromWindow(WidgetsBinding.instance.window)
                              .size
                              .height *
                          0.7,
                ),
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: AppTheme.getInstance().backgroundColor(),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (titleWidget != null) ...[
                      titleWidget,
                      spaceH40,
                    ],
                    if (title != null) ...[
                      Text(
                        title,
                        style: TextStyleCustom.textSemiBold16,
                        textAlign: TextAlign.center,
                      ),
                      spaceH24,
                    ],
                    SizedBox(
                      child: Text(
                        content,
                        style: TextStyleCustom.textRegular12,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    if (contentWidget != null) contentWidget,
                    if (positive != null || negative != null) ...[
                      spaceH40,
                      Row(
                        children: [
                          if (negative != null)
                            Expanded(
                              child: ButtonCustom(
                                text: negative,
                                onPressed: negativeClick ?? () {},
                                background:
                                    AppTheme.getInstance().primaryColor(),
                                foregroundColor:
                                    colorBlack85,
                              ),
                            ),
                          if (negative != null && positive != null) spaceW8,
                          if (positive != null)
                            Expanded(
                              child: ButtonCustom(
                                text: positive,
                                onPressed: positiveClick ?? () {},
                              ),
                            ),
                        ],
                      )
                    ]
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ).then((_) {
      onClose?.call();
    });
  }
}

Future<bool?> showToast(
  String msg, {
  Toast length = Toast.LENGTH_SHORT,
  ToastGravity gravity = ToastGravity.BOTTOM,
}) {
  Fluttertoast.cancel();
  return Fluttertoast.showToast(
    msg: msg,
    toastLength: length,
    gravity: gravity,
    fontSize: 14,
    backgroundColor: Colors.black,
    textColor: Colors.white.withOpacity(0.8),
  );
}
