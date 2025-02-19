import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hapycar/config/resources/color.dart';
import 'package:hapycar/config/resources/styles.dart';

class PrefixIcon extends StatelessWidget {
  const PrefixIcon({
    Key? key,
    required this.icon, this.required = true,

  }) : super(key: key);
  final String icon;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          icon,
          height: 16,
          width: 16,
        ),
        if(required)
          Text(
            '*',
            style: TextStyleCustom.f12w400.apply(
              color: colorPrimary,
            ),
          ),
      ],
    );
  }
}
