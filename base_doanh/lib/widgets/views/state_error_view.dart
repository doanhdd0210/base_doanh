import 'package:flutter/material.dart';
import 'package:base_doanh/config/resources/styles.dart';
import 'package:base_doanh/generated/l10n.dart';
import 'package:base_doanh/utils/style_utils.dart';
import 'package:base_doanh/widgets/app_button.dart';

class StateErrorView extends StatelessWidget {
  final String? _message;
  final Function() _retry;

  const StateErrorView(this._message, this._retry, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _message ?? S.of(context).something_went_wrong,
            style: TextStyleCustom.textRegular14,
              textAlign: TextAlign.center,
          ),
          spaceH15,
          AppButton(
            S.of(context).retry,
            _retry,
            borderRadius: 8,
            width: 90,
          ),
        ],
      ),
    );
  }
}
