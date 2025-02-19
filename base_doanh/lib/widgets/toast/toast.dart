import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hapycar/config/resources/color.dart';
import 'package:hapycar/config/resources/styles.dart';
import 'package:hapycar/utils/constants/image_asset.dart';
import 'package:hapycar/utils/screen_controller.dart';
import 'package:hapycar/utils/style_utils.dart';

enum ToastState {
  SUCCESS,
  ERROR,
  WARNING,
}

Future<void> showToastM(
  BuildContext context, {
  String? image,
  String? message,
  String? title,
  EdgeInsets? margin,
  bool autoClose = true,
  bool hasClose = true,
  Widget? action,
  ToastState state = ToastState.ERROR,
  Duration? durationClose,
}) async {
  final toast = FToast();
  toast.init(context);
  toast.removeQueuedCustomToasts();
  toast.showToast(
    child: ToastView(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 0, vertical: 24),
      message: message,
      image: Image.asset(
        image ?? state.getIcon(),
        height: 24,
        width: 24,
      ),
      title: title,
      state: state,
      action: action,
    ),
  );
}

extension ToastStateExt on ToastState {
  Color getColor() {
    switch (this) {
      case ToastState.SUCCESS:
        return colorWhite;
      case ToastState.ERROR:
        return colorWhite;
      case ToastState.WARNING:
        return colorWhite;
    }
  }

  Color getColorTitle() {
    switch (this) {
      case ToastState.SUCCESS:
        return colorBlack85;
      case ToastState.ERROR:
        return colorBlack85;
      case ToastState.WARNING:
        return colorBlack85;
    }
  }

  String getIcon() {
    switch (this) {
      case ToastState.SUCCESS:
        return ImageAssets.icSuccess;
      case ToastState.ERROR:
        return ImageAssets.icError;
      case ToastState.WARNING:
        return ImageAssets.icSuccess;
    }
  }
}

class ToastCustom extends StatefulWidget {
  const ToastCustom({
    Key? key,
    this.image,
    this.message,
    this.autoClose = true,
    this.action,
    this.state = ToastState.SUCCESS,
    this.durationClose,
    required this.hasClose,
    this.title,
  }) : super(key: key);

  final Widget? image;
  final String? message;
  final String? title;
  final bool autoClose;
  final bool hasClose;
  final Widget? action;
  final ToastState state;
  final Duration? durationClose;

  @override
  State<ToastCustom> createState() => _DialogIconState();
}

class _DialogIconState extends State<ToastCustom> {
  @override
  void initState() {
    super.initState();
    if (widget.autoClose) {
      Future.delayed(widget.durationClose ?? const Duration(milliseconds: 1000),
          () {
        if (mounted) {
          closeScreen(context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () {
          if (widget.hasClose) {
            closeScreen(context);
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ToastView(
              image: widget.image,
              title: widget.title,
              action: widget.action,
              message: widget.message,
              state: widget.state,
            )
          ],
        ),
      ),
    );
  }
}

class ToastView extends StatelessWidget {
  const ToastView({
    Key? key,
    this.image,
    this.message,
    this.title,
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
    this.action,
    this.state = ToastState.ERROR,
  }) : super(key: key);

  final Widget? image;
  final String? message;
  final String? title;
  final Widget? action;
  final ToastState state;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: state.getColor(),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: colorNote,
            blurRadius: 15,
            offset: Offset(0, 12),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 19,
        vertical: 16,
      ),
      margin: margin,
      child: Row(
        children: [
          image ??
              ImageAssets.svgAssets(
                state.getIcon(),
              ),
          spaceW16,
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null)
                  Text(
                    title ?? '',
                    style: TextStyleCustom.f14w500
                        .apply(color: state.getColorTitle()),
                  ),
                if (message != null)
                  Text(
                    message ?? '',
                    style: TextStyleCustom.f12w400,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
