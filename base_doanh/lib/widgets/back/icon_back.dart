import 'package:flutter/material.dart';

import '../../utils/constants/image_asset.dart';
import '../../utils/screen_controller.dart';

class IconBack extends StatelessWidget {
  const IconBack({
    Key? key,
    this.color,
    this.ic,
    this.onTap,
  }) : super(key: key);
  final Color? color;
  final String? ic;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    double size = ic != null ? 20 : 24;
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!();
        } else {
          closeScreen(context);
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Image.asset(
          ic ?? ImageAssets.icBack,
          width: size,
          height: size,
          color: color,
        ),
      ),
    );
  }
}
