import 'package:flutter/material.dart';
import 'package:base_doanh/config/resources/styles.dart';
import 'package:base_doanh/utils/get_ext.dart';

class AndroidDialog extends StatelessWidget {
  final bool? onWillPop;
  final String? title;
  final String? content;
  final TextStyle? titleStyle;
  final TextStyle? contentStyle;
  final String? ok;
  final String? cancel;
  final Function? onConfirm;
  final Function? onCancel;

  const AndroidDialog({
    Key? key,
    this.onWillPop,
    this.title,
    @required this.content,
    this.titleStyle,
    this.contentStyle,
    this.ok,
    this.cancel,
    this.onConfirm,
    this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => onWillPop ?? false,
      child: AlertDialog(
        title: title != null
            ? Text(
                title ?? '',
                style: titleStyle ?? textNormal(null, 16),
              )
            : null,
        content: Text(
          content ?? '',
          style: contentStyle ?? textNormal(null, 14),
        ),
        actions: <Widget>[
          Visibility(
            visible: cancel != null,
            child: TextButton(
              child: Text(
                cancel ?? 'Cancel',
                style: textNormal(null, 14),
              ),
              onPressed: () {
                finish();
                if (onCancel != null) onCancel!();
              },
            ),
          ),
          TextButton(
            child: Text(
              ok ?? 'OK',
              style: textNormal(null, 14),
            ),
            onPressed: () {
              finish();
              if (onConfirm != null) onConfirm!();
            },
          ),
        ],
      ),
    );
  }
}
