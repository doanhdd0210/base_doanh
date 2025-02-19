import 'package:hapycar/config/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:hapycar/utils/constants/image_asset.dart';

class CloseTextBase extends StatefulWidget {
  final TextEditingController textEditingController;

  const CloseTextBase({
    Key? key,
    required this.textEditingController,
  }) : super(key: key);

  @override
  _CloseTextBaseState createState() => _CloseTextBaseState();
}

class _CloseTextBaseState extends State<CloseTextBase> {
  @override
  void initState() {
    widget.textEditingController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.textEditingController.text = '';
      },
      child: widget.textEditingController.text.isNotEmpty
          ? Padding(
              padding: EdgeInsets.only(
                top: 10,
                bottom: 10,
                // right: 8,
              ),
              child: Image.asset(
                ImageAssets.icClose,
                color: AppTheme.getInstance().blackColors(),
                height: 16,
                width: 16,
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}

class CloseTextBase2 extends StatefulWidget {
  final TextEditingController textEditingController;
  final Function onClose;
  const CloseTextBase2({
    Key? key,
    required this.textEditingController,
    required this.onClose,
  }) : super(key: key);

  @override
  _CloseTextBase2State createState() => _CloseTextBase2State();
}

class _CloseTextBase2State extends State<CloseTextBase2> {
  @override
  void initState() {
    widget.textEditingController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.textEditingController.text = '';
        widget.onClose();
      },
      child: widget.textEditingController.text.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 5,
              ),
              child: Image.asset(
                ImageAssets.icError,
                color: AppTheme.getInstance().greyTextColor(),
              ),
            )
          : const SizedBox(
              width: 4,
            ),
    );
  }
}
