import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hapycar/config/resources/styles.dart';
import 'package:hapycar/config/themes/app_theme.dart';
import 'package:hapycar/utils/style_utils.dart';
import 'package:hapycar/widgets/button/button_custom.dart';

class DialogUtils {
  static void dismiss() {
    if (Get.isDialogOpen == true) Get.back();
  }

  static void showDialog({
    TextAlign? titleAlign,
    String? title,
    required String content,
    Widget? contentWidget,
    Widget? titleWidget,
    bool barrierDismissible = true,
    String? positive,
    String? negative,
    ButtonType negativeButtonType = ButtonType.PRIMARY,
    ButtonType positiveButtonType = ButtonType.PRIMARY,
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
                  maxHeight: MediaQuery.of(Get.context!).size.height * 0.7,
                ),
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
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
                      spaceH24,
                    ],
                    if (title != null) ...[
                      Text(
                        title,
                        style: TextStyleCustom.f16w600,
                        textAlign: TextAlign.center,
                      ),
                      spaceH24,
                    ],
                    SizedBox(
                      child: Text(
                        content,
                        style: TextStyleCustom.f14w500,
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
                                size: ButtonSize.SMALL,
                                type: negativeButtonType,
                                text: negative,
                                onPressed: negativeClick ?? () {},
                                background:
                                    AppTheme.getInstance().primaryColor(),
                              ),
                            ),
                          if (negative != null && positive != null) spaceW16,
                          if (positive != null)
                            Expanded(
                              child: ButtonCustom(
                                size: ButtonSize.SMALL,
                                type: positiveButtonType,
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
                  maxHeight: MediaQuery.of(Get.context!).size.height * 0.7,
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
                        style: TextStyleCustom.f16w600,
                        textAlign: TextAlign.center,
                      ),
                      spaceH24,
                    ],
                    SizedBox(
                      child: Text(
                        content,
                        style: TextStyleCustom.f12w400,
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
