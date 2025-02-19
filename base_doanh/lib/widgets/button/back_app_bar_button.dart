import 'package:flutter/material.dart';
import 'package:hapycar/utils/constants/image_asset.dart';

class BackAppBar extends StatelessWidget {
  const BackAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Center(
        child: ImageAssets.svgAssets(ImageAssets.icSuccess),
      ),
    );
  }
}
