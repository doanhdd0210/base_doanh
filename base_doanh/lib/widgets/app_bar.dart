import 'package:flutter/material.dart';
import 'package:base_doanh/config/resources/styles.dart';

import 'button/back_app_bar_button.dart';

class BaseAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;
  final Widget? leadingIcon;
  final String title;
  final Color? backGroundColor;
  final Widget? widgetTitle;
  final List<Widget>? actions;
  final bool isBack;
  final EdgeInsetsGeometry? padding;

  BaseAppBar({
    Key? key,
    required this.title,
    this.leadingIcon,
    this.actions,
    this.widgetTitle,
    this.backGroundColor,
    this.isBack = true,
    this.padding,
  })  : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backGroundColor,
      bottomOpacity: 0.0,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Padding(
        padding: padding ??
            const EdgeInsets.only(
              left: 12,
              right: 12,
            ),
        child: widgetTitle ??
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (isBack)
                  const BackAppBar()
                else
                  const SizedBox(
                    height: 40,
                    width: 40,
                  ),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyleCustom.textRegular14,
                    textAlign: TextAlign.center,
                  ),
                ),
                ...actions ??
                    [
                      const SizedBox(
                        height: 40,
                        width: 40,
                      ),
                    ],
              ],
            ),
      ),
      centerTitle: true,
      leading: leadingIcon,
    );
  }
}
