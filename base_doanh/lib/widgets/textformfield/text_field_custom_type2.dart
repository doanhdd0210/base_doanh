import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rxdart/rxdart.dart';
import 'package:base_doanh/config/resources/color.dart';
import 'package:base_doanh/config/resources/styles.dart';
import 'package:base_doanh/utils/constants/image_asset.dart';
import 'package:base_doanh/utils/style_utils.dart';
import 'package:base_doanh/widgets/textformfield/close_text_base.dart';
import 'package:base_doanh/widgets/textformfield/prefix_icon.dart';
import 'package:base_doanh/widgets/textformfield/text_validate.dart';

class FormInputBase extends StatefulWidget {
  const FormInputBase({
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
  }) : super(key: key);

  final bool isClose;
  final String? icon;
  final String hintText;
  final Widget? suffixWidget;
  final BoxConstraints? suffixConstraint;
  final String? initText;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final String? Function(String)? validateFun;
  final Function(String) onChange;
  final TextInputType? textInputType;
  final bool isPass;
  final bool fullWidth;
  final Widget? suffix;
  final TextEditingController? controller;
  final Widget? iconWidget;
  final bool enabled;
  final bool required;
  final Function()? onTap;
  final int? maxLine;

  @override
  FormInputBaseState createState() => FormInputBaseState();
}

class FormInputBaseState extends State<FormInputBase> {
  late TextEditingController textEditingController;

  bool isPass = false;
  final BehaviorSubject<String?> textValidate = BehaviorSubject<String?>();
  final BehaviorSubject<bool> active = BehaviorSubject<bool>.seeded(false);
  bool validateCall = false;
  final FocusNode focus = FocusNode();

  @override
  void initState() {
    super.initState();
    isPass = widget.isPass;
    textEditingController = widget.controller ?? TextEditingController();
    if (widget.initText?.isNotEmpty ?? false) {
      textEditingController.text = widget.initText!;
      widget.onChange(widget.initText!);
      active.add(true);
    }
    textEditingController.addListener(() {
      active.add(textEditingController.value.text.isNotEmpty);
    });
  }

  @override
  void dispose() {
    super.dispose();
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: colorBlack4,
            borderRadius: BorderRadius.circular(
              8,
            ),
          ),
          width: widget.fullWidth ? MediaQuery.of(context).size.width : null,
          child: Row(
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
                  style: TextStyleCustom.textMedium16.apply(
                    color: colorBlack85,
                  ),
                  validator: (text) {
                    validateCall = true;
                    return validate(text);
                  },
                  onChanged: (text) {
                    widget.onChange(text);
                    validate(text);
                  },
                  focusNode: focus,
                  onTap: widget.onTap,
                  inputFormatters: widget.inputFormatters,
                  keyboardType: widget.textInputType,
                  controller: textEditingController,
                  maxLength: widget.maxLength,
                  textAlignVertical: TextAlignVertical.center,
                  obscureText: isPass,
                  maxLines: widget.maxLine == null ? 1 : null,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    isCollapsed: true,
                    enabled: widget.enabled,
                    counterText: '',
                    hintText: widget.hintText,
                    hintStyle: TextStyleCustom.textRegular14.apply(
                      color: colorTextSecondary,
                    ),
                    errorStyle: const TextStyle(fontSize: 0, height: 0.1),
                    border: InputBorder.none,
                    suffixIconConstraints: widget.suffixConstraint ??
                        const BoxConstraints(
                          minHeight: 24,
                          minWidth: 24,
                          maxHeight: 24,
                          maxWidth: 60,
                        ),
                    constraints: const BoxConstraints(
                      maxHeight: 80,
                    ),
                    suffixIcon: suffixIcon(),
                  ),
                ),
              ),
            ],
          ),
        ),
        StreamBuilder<String?>(
          stream: textValidate,
          builder: (_, data) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                spaceH4,
                ValidateTextBase(
                  textValidate: data.data ?? '',
                ),
              ],
            );
          },
        ),
      ],
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
      return GestureDetector(
        onTap: () => setState(() {
          isPass = !isPass;
        }),
        child: SvgPicture.asset(
          isPass ? ImageAssets.icSuccess : ImageAssets.icSuccess, //todo
        ),
      );
    } else {
      return widget.suffix;
    }
  }
}
