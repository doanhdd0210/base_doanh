import 'package:hapycar/widgets/input_history_text_field/input_history_controller.dart';
import 'package:flutter/material.dart';
import '../../config/resources/styles.dart';
import '../../config/themes/app_theme.dart';
import '../../presentation/language/language_data.dart';
import '../../utils/constants/image_asset.dart';
import '../../utils/extensions/common_ext.dart';
import 'input_history_text_field.dart';

class ActionHeart extends StatefulWidget {
  const ActionHeart({
    Key? key,
    required this.onTap,
  }) : super(key: key);
  final Function(bool) onTap;
  @override
  State<ActionHeart> createState() => _ActionHeartState();
}

class _ActionHeartState extends State<ActionHeart> {
  bool isHeart = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        isHeart = !isHeart;
        widget.onTap(isHeart);
        setState(() {});
      },
      child: Image.asset(
        isHeart ? ImageAssets.icHeartBold : ImageAssets.icHeart,
        width: 20,
        height: 20,
        color: isHeart ? AppTheme.getInstance().redColors() : null,
      ),
    );
  }
}

Future<void> delayFunction() async {
  await Future.delayed(Duration(milliseconds: 2000));
}

class InputHistoryBase extends StatefulWidget {
  const InputHistoryBase({
    Key? key,
    required this.inputHistoryController,
    required this.historyKey,
    required this.onAction,
    this.autofocus = false,
    this.hint,
    this.textEditingController,
  }) : super(key: key);
  final InputHistoryController inputHistoryController;
  final String historyKey;
  final Function(String v) onAction;
  final bool autofocus;
  final String? hint;
  final TextEditingController? textEditingController;
  @override
  State<InputHistoryBase> createState() => _InputHistoryBaseState();
}

class _InputHistoryBaseState extends State<InputHistoryBase> {
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    if (widget.textEditingController != null) {
      _textEditingController = widget.textEditingController!;
    } else {
      _textEditingController = TextEditingController();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.getInstance().colorFFF2F2F2(),
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        child: InputHistoryTextField(
          textEditingController: _textEditingController,
          onSubmitted: (v) {
            widget.onAction(v);
          },
          textInputAction: TextInputAction.search,
          scrollPhysics: AlwaysScrollableScrollPhysics(),
          autofocus: widget.autofocus,
          inputHistoryController: widget.inputHistoryController,
          historyKey: widget.historyKey,
          minLines: 1,
          maxLines: 1,
          limit: 100, //khoong gioi han
          enableHistory: true,
          hasFocusExpand: true,
          enableOpacityGradient: false,
          decoration: InputDecoration(
            isCollapsed: true,
            contentPadding: EdgeInsets.symmetric(vertical: 12),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppTheme.getInstance().colorFF7210ff(),
              ),
              borderRadius: BorderRadius.all(Radius.circular(10)),
              gapPadding: 0,
            ),
            border: InputBorder.none,
            prefixIcon: Padding(
              padding: const EdgeInsets.only(
                right: 6,
                left: 12,
              ),
              child: Image.asset(
                ImageAssets.icSearch,
                color: AppTheme.getInstance().blackColors(),
              ),
            ),
            prefixIconConstraints: BoxConstraints(
              maxWidth: 36,
              maxHeight: 16,
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(left: 6, right: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      _textEditingController.clear();
                      widget.onAction(_textEditingController.text);
                    },
                    child: IconClose(
                      textEditingController: _textEditingController,
                    ),
                  ),
                  // Image.asset(
                  //   ImageAssets.icSetting,
                  //   color: AppTheme.getInstance().blackColors(),
                  //   height: 16,
                  //   width: 16,
                  // ),
                ],
              ),
            ),
            suffixIconConstraints: BoxConstraints(
              maxWidth: 68,
              maxHeight: 16,
            ),
            hintText: widget.hint ??Lang.key(keyT.SEARCH),
            hintStyle: TextStyleCustom.f14w500.copyWith(
              color: AppTheme.getInstance().greyTextColor(),
            ),
          ),
          listDecoration: BoxDecoration(
            color: Colors.white,
          ),
          listOffset: Offset(0, 5),
          historyListItemLayoutBuilder: (controller, value, index) {
            return InkWell(
              onTap: () {
                widget.onAction(value.text);
                controller.select(value.text);
                closeKey();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        value.textToSingleLine,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyleCustom.f16w500.copyWith(
                          color: AppTheme.getInstance().blackColors(),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => controller.remove(value),
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppTheme.getInstance().blackColors(),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        child: Icon(
                          Icons.close,
                          size: 12,
                          color: AppTheme.getInstance().blackColors(),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class IconClose extends StatefulWidget {
  const IconClose({
    Key? key,
    required this.textEditingController,
  }) : super(key: key);
  final TextEditingController textEditingController;
  @override
  State<IconClose> createState() => _IconCloseState();
}

class _IconCloseState extends State<IconClose> {
  @override
  void initState() {
    widget.textEditingController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.textEditingController.text != '')
      return Container(
        margin: EdgeInsets.only(
          right: 8,
        ),
        child: Image.asset(
          ImageAssets.icError,
          color: AppTheme.getInstance().greyTextColor(),
          height: 16,
          width: 16,
        ),
      );
    return SizedBox.shrink();
  }
}
