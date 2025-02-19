import 'package:flutter/material.dart';
import 'package:hapycar/config/resources/color.dart';
import 'package:hapycar/config/resources/styles.dart';

class ValidateTextBase extends StatelessWidget {
  const ValidateTextBase({
    Key? key,
    required this.textValidate,
  }) : super(key: key);
  final String textValidate;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: textValidate.isNotEmpty
          ? Text(
              textValidate,
              style: TextStyleCustom.f12w400.apply(
                color: colorError,
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
