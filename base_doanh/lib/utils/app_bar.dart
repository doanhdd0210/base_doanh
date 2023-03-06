import 'package:flutter/material.dart';
import 'package:base_doanh/config/resources/styles.dart';
import 'package:base_doanh/utils/constants/image_asset.dart';
import 'package:base_doanh/utils/screen_controller.dart';

class AppBarNormal extends AppBar with PreferredSizeWidget {
  AppBarNormal({
    Key? key,
    required BuildContext context,
    required dynamic title,
    Widget? leading,
    dynamic action,
    onRightTap,
    Color? backgroundColor,
  }) : super(
    key: key,

          // leadingWidth: 82,
          elevation: 0.0,

          backgroundColor: backgroundColor ?? Colors.white,

          title: title is String
              ? buildTitle(
                  context,
                  title,
                  action,
                )
              : title,
          leading: _buildLeading(leading, context),

          centerTitle: true,

          actions: action is List<Widget>
              ? action
              : [
                  if (action != null)
                    Center(
                      child: buildAppBarButton(
                        action,
                        onPressed: onRightTap,
                        margin: const EdgeInsets.only(
                          right: 20,
                        ),
                      ),
                    )
                  else
                    const SizedBox.shrink()
                ].toList(),
        );

  @override
  Size get preferredSize => const Size.fromHeight(56);
}

Widget _buildLeading(Widget? child, BuildContext context) {
  return buildAppBarButton(
    child ?? ImageAssets.svgAssets(ImageAssets.icSuccess),
    onPressed: () {
      closeScreen(context);
    },
    margin: const EdgeInsets.only(left: 20),
  );
}

Widget buildAppBarButton(
  Widget child, {
  Function? onPressed,
  EdgeInsets? margin,
}) {
  final ButtonStyle outlineButtonStyle = OutlinedButton.styleFrom(
    primary: Colors.black87,
    padding: const EdgeInsets.all(4),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
  );
  return Center(
    child: Container(
      height: 32,
      width: 32,
      margin: margin ?? EdgeInsets.zero,
      child: AspectRatio(
        aspectRatio: 1,
        child: OutlinedButton(
          style: outlineButtonStyle,
          onPressed: () {
            onPressed?.call();
          },
          child: child,
        ),
      ),
    ),
  );
}

Widget buildTitle(BuildContext context, String title, dynamic action) {
  final actionSize = action == null
      ? 0
      : action is List
          ? action.length
          : 1;
  final right = actionSize > 0 ? actionSize : 1;
  final paddingRight = right * 30 + 20;
  return GestureDetector(
    child: Container(
      color: Colors.transparent,
      margin: EdgeInsets.only(right: actionSize == 0 ? paddingRight * 1.0 : 0),
      child: Center(
        child: Text(
          title,
          textScaleFactor: 1,
          style: textNormal(null, 16),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ),
  );
}
