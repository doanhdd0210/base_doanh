import 'package:flutter/material.dart';
import 'package:hapycar/config/themes/app_theme.dart';
import 'package:hapycar/utils/app_utils.dart';
import 'package:hapycar/utils/style_utils.dart';

class ContainerBottomSheet extends StatelessWidget {
  const ContainerBottomSheet({
    Key? key,
    required this.child,
    this.borderTop = true,
  }) : super(key: key);
  final Widget child;
  final bool borderTop;

  @override
  Widget build(BuildContext context) {
    const border = Radius.circular(30);
    return Container(
      width: getWithSize(context),
      padding: const EdgeInsets.only(top: 12, bottom: 24),
      decoration: BoxDecoration(
        borderRadius: borderTop
            ? const BorderRadius.only(
                topRight: border,
                topLeft: border,
              )
            : const BorderRadius.only(
                bottomRight: border,
                bottomLeft: border,
              ),
        color: AppTheme.getInstance().backgroundColor(),
        boxShadow: boxShadowBase,
      ),
      child: child,
    );
  }
}
