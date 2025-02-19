import 'package:hapycar/config/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:hapycar/config/resources/color.dart';
import 'package:hapycar/config/resources/styles.dart';
import 'package:hapycar/utils/constants/image_asset.dart';
import 'package:hapycar/utils/style_utils.dart';
import 'package:hapycar/widgets/text_form_field/close_text_base.dart';
import 'package:hapycar/widgets/text_form_field/prefix_icon.dart';

class TextFieldHapyCar extends StatefulWidget {
  const TextFieldHapyCar({
    Key? key,
    required this.hintText,
    this.initText,
    this.validateFun,
    this.textInputType,
    this.isClose = false,
    this.maxLength = 255,
    this.icon,
    this.suffixConstraint,
    this.isPass = false,
    required this.onChange,
    this.iconWidget,
    this.enabled = true,
    this.onTap,
    this.controller,
    this.maxLine,
    this.inputFormatters,
    this.suffix,
    this.suffixWidget,
    this.fullWidth = true,
    this.required = true,
    this.title,
    this.prefix,
    this.prefixConstraint,
    this.textInputAction,
    this.colorBorder,
    this.colorText,
    this.isWrap = false,
    this.isBorder = true,
    this.autofocus = false,
    this.colorTitle,
    this.onFocus,
    this.lable,
  }) : super(key: key);

  final bool isClose;
  final String? icon;
  final String? title;
  final String? lable;
  final String hintText;
  final Widget? suffixWidget;
  final BoxConstraints? suffixConstraint;
  final BoxConstraints? prefixConstraint;
  final String? initText;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final String? Function(String)? validateFun;
  final Function(String) onChange;
  final TextInputType? textInputType;
  final bool isPass;
  final bool fullWidth;
  final Widget? suffix;
  final Widget? prefix;
  final TextEditingController? controller;
  final Widget? iconWidget;
  final bool enabled;
  final bool required;
  final Function()? onTap;
  final Function(bool)? onFocus;
  final int? maxLine;
  final TextInputAction? textInputAction;
  final Color? colorBorder;
  final Color? colorText;
  final Color? colorTitle;
  final bool isWrap;
  final bool isBorder;
  final bool autofocus;

  @override
  TextFieldHapyCarState createState() => TextFieldHapyCarState();
}

class TextFieldHapyCarState extends State<TextFieldHapyCar> {
  late TextEditingController textEditingController;

  bool isPass = false;
  final BehaviorSubject<String?> textValidate = BehaviorSubject<String?>();
  final BehaviorSubject<bool> active = BehaviorSubject<bool>.seeded(false);
  bool validateCall = false;
  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    isPass = widget.isPass;
    textEditingController = widget.controller ?? TextEditingController();
    if (widget.initText?.isNotEmpty ?? false) {
      textEditingController.text = widget.initText ?? '';
      widget.onChange(widget.initText ?? '');
      active.add(true);
    }
    _focus.addListener(() {
      widget.onFocus != null ? widget.onFocus!(_focus.hasFocus) : null;
    });
    textEditingController.addListener(() {
      active.add(textEditingController.value.text.isNotEmpty);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _focus.dispose();
    if (widget.controller == null) {
      textEditingController.dispose();
    }
  }

  String? validate(String? text) {
    final errorText = widget.validateFun?.call(
      textEditingController.text,
    );
    textValidate.sink.add(errorText);
    return errorText;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.isWrap ? null : EdgeInsets.symmetric(horizontal: 24),
      width: widget.fullWidth ? MediaQuery.of(context).size.width : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null) ...[
            Text(
              widget.title ?? '',
              style: TextStyleCustom.f16w600.apply(
                color: widget.colorTitle ?? AppTheme.getInstance().whiteColor(),
              ),
            ),
            spaceH16,
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon?.isNotEmpty ?? false)
                StreamBuilder<bool>(
                  stream: active,
                  builder: (_, snapshot) {
                    return Padding(
                      padding: EdgeInsets.only(
                        top: widget.maxLine != null ? 2 : 0,
                        right: 12,
                      ),
                      child: PrefixIcon(
                        icon: widget.icon ?? '',
                        required: widget.required,
                      ),
                    );
                  },
                ),
              Expanded(
                child: TextFormField(
                  autofocus: widget.autofocus,
                  textInputAction: widget.textInputAction,
                  style: TextStyleCustom.f14w500.apply(
                    color:
                        widget.colorText ?? AppTheme.getInstance().whiteColor(),
                  ),
                  validator: (text) {
                    validateCall = true;
                    return validate(text);
                  },
                  onChanged: (text) {
                    widget.onChange(text);
                    validate(text);
                  },
                  focusNode: _focus,
                  onTap: widget.onTap,
                  inputFormatters: widget.inputFormatters,
                  keyboardType: widget.textInputType,
                  controller: textEditingController,
                  maxLength: widget.maxLength,
                  textAlignVertical: TextAlignVertical.center,
                  obscureText: isPass,
                  maxLines: widget.maxLine == null ? 1 : null,
                  decoration: InputDecoration(
                    labelText: widget.lable,
                    labelStyle: TextStyleCustom.f14w500.copyWith(
                      color: AppTheme.getInstance().greyTextColor(),
                    ),
                    contentPadding: EdgeInsets.only(
                      bottom: 14,
                    ),
                    isCollapsed: widget.lable == null,
                    enabled: widget.enabled,
                    counterText: '',
                    hintText: widget.hintText,
                    hintStyle: TextStyleCustom.f14w500.apply(
                      color: widget.colorBorder ?? colorTextSecondary,
                    ),
                    errorStyle: TextStyleCustom.f14w500.apply(
                      color: Colors.red,
                    ),
                    focusedBorder: widget.isBorder
                        ? UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: widget.colorText ?? Colors.white,
                            ),
                          )
                        : InputBorder.none,
                    errorBorder: widget.isBorder
                        ? UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                            ),
                          )
                        : InputBorder.none,
                    enabledBorder: widget.isBorder
                        ? UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: widget.colorBorder ?? colorTextSecondary,
                            ),
                          )
                        : InputBorder.none,
                    suffixIconConstraints: widget.suffixConstraint ??
                        const BoxConstraints(
                          minHeight: 32,
                          minWidth: 32,
                          maxHeight: 32,
                          maxWidth: 60,
                        ),
                    constraints: const BoxConstraints(
                      maxHeight: 80,
                    ),
                    prefixIconConstraints: widget.prefixConstraint ??
                        const BoxConstraints(
                          minHeight: 30,
                          minWidth: 36,
                          maxHeight: 36,
                          maxWidth: 60,
                        ),
                    suffixIcon: widget.suffix ?? suffixIcon(),
                    prefixIcon: widget.prefix,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget? suffixIcon() {
    if (widget.iconWidget != null) {
      return widget.iconWidget;
    }
    if (widget.isClose) {
      return CloseTextBase(
        textEditingController: textEditingController,
      );
    } else if (widget.isPass) {
      return StreamBuilder<bool>(
          stream: active,
          builder: (context, snapshot) {
            return snapshot.data == true
                ? GestureDetector(
                    onTap: () => setState(() {
                      isPass = !isPass;
                    }),
                    child: Container(
                      padding: EdgeInsets.only(
                        bottom: 14,
                      ),
                      child: Image.asset(
                        isPass ? ImageAssets.icShow : ImageAssets.icHide,
                        color: Colors.white,
                        fit: BoxFit.contain,
                      ),
                    ),
                  )
                : SizedBox();
          });
    } else {
      return widget.suffix;
    }
  }
}
