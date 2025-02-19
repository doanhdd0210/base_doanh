import 'package:flutter/material.dart';
import 'package:hapycar/config/themes/app_theme.dart';

class LoadingItem extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: AppTheme.getInstance().primaryColor(),
      ),
    );
  }
}
