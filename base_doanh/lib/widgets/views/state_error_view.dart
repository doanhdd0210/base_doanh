import 'package:flutter/material.dart';
import 'package:hapycar/config/resources/styles.dart';

import 'package:hapycar/utils/style_utils.dart';
import 'package:hapycar/widgets/app_button.dart';

import '../../presentation/language/language_data.dart';

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
            _message ?? Lang.key(keyT.SOMETHING_WENT_WRONG),
            style: TextStyleCustom.f14w400,
            textAlign: TextAlign.center,
          ),
          spaceH15,
          AppButton(
            Lang.key(keyT.RETRY),
            _retry,
            borderRadius: 8,
            width: 90,
          ),
        ],
      ),
    );
  }
}
