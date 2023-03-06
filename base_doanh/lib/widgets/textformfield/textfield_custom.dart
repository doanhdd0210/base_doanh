import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:base_doanh/config/base/rx.dart';
import 'package:base_doanh/config/resources/color.dart';
import 'package:base_doanh/config/resources/styles.dart';
import 'package:base_doanh/utils/constants/image_asset.dart';
import 'package:base_doanh/widgets/button/button_custom.dart';
enum TextFieldState { DEFAULT, ERROR, SUCCESS, FOCUS, DISABLED }

class TextFieldCustom extends StatefulWidget {
  final String? placeholder;
  final String? value;
  final TextEditingController? textEditingController;
  final TextFieldState state;
  final String? helperText;
  final int? maxlengh;
  final Widget? leftIcon;
  final Widget? rightIcon;
  final bool disableAutoCorrection;
  final bool secureField;
  final Color background;
  final Color disabledBackground;
  final Color placeholderColor;
  final Color textfieldColor;
  final Color disabledTextfieldColor;
  final Color borderDefaultColor;
  final Color borderDisabledColor;
  final Color borderErrorColor;
  final Color borderSuccessColor;
  final Color borderFocusColor;
  final Color errorHelperTextColor;
  final double paddingErrorText;
  final TextInputType keyboardType;
  final Function(String)? onChange;
  final Function(String)? validate;
  final List<TextInputFormatter>? inputFormatters;
  final Function()? onTap;
  final double borderWidth;
  final EdgeInsets? contentPadding;
  final Widget? prefix;
  final String? prefixText;
  final bool autoTrim;
  final bool useNumberRegex;
  final bool autoDisposeController;
  final bool showClearIcon;
  final bool isRequire;
  final bool isDropdown;

  const TextFieldCustom({
    Key? key,
    this.placeholder,
    this.maxlengh,
    this.inputFormatters,
    this.value,
    this.textEditingController,
    this.state = TextFieldState.DEFAULT,
    this.disableAutoCorrection = true,
    this.helperText,
    this.leftIcon,
    this.rightIcon,
    this.secureField = false,
    this.background = Colors.white,
    this.placeholderColor = colorTextSecondary,
    this.textfieldColor = colorTextTitle,
    this.disabledTextfieldColor = colorTextTitle,
    this.borderDefaultColor = colorBorder,
    this.borderDisabledColor = colorBorder,
    this.borderErrorColor = colorError,
    this.borderSuccessColor = colorBorder,
    this.borderFocusColor = colorTextPrimary,
    this.errorHelperTextColor = colorError,
    this.keyboardType = TextInputType.text,
    this.paddingErrorText = 20.0,
    this.onChange,
    this.validate,
    this.onTap,
    this.borderWidth = 1,
    this.contentPadding,
    this.prefix,
    this.autoTrim = true,
    this.prefixText,
    this.useNumberRegex = false,
    this.autoDisposeController = false,
    this.showClearIcon = true,
    this.isRequire = true,
    this.isDropdown = false,
    this.disabledBackground = colorDisable,
  }) : super(key: key);

  @override
  TextFieldCustomState createState() => TextFieldCustomState();
}

class TextFieldCustomState extends State<TextFieldCustom> {
  BehaviorSubject<String?> errTextSubject = BehaviorSubject();
  BehaviorSubject<bool> hasStringSubject = BehaviorSubject();
  String? errText;
  late final TextEditingController _controller;
  late FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();
    _controller = widget.textEditingController ?? TextEditingController();
    myFocusNode = FocusNode();
    _controller.addListener(() {
      hasStringSubject.wellAdd(_controller.value.text.isNotEmpty);
      if (widget.useNumberRegex) {
        _controller.addListener(() {
          final String text = _controller.text.toLowerCase();
          _controller.value = _controller.value.copyWith(
            text: text,
            selection: TextSelection(
              baseOffset: text.length,
              extentOffset: text.length,
            ),
            composing: TextRange.empty,
          );
        });
      }
    });
    if (widget.value != null) {
      hasStringSubject.wellAdd(true);
      _controller.text = widget.value!;
    }
  }

  @override
  void dispose() {
    if (widget.autoDisposeController) {
      _controller.dispose();
      hasStringSubject.close();
      errTextSubject.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.isDropdown
              ? null
              : () {
                  myFocusNode.requestFocus();
                },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: widget.state == TextFieldState.DISABLED
                  ? widget.disabledBackground
                  : widget.background,
              border: Border.all(
                color: widget.borderDefaultColor,
                width: widget.borderWidth,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.placeholder != null)
                        StreamBuilder<bool>(
                          stream: hasStringSubject,
                          builder: (context, snapshot) {
                            final hasString = snapshot.data ?? false;
                            return hasString
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 2.0,
                                    ),
                                    child: RichText(
                                      text: TextSpan(
                                        text: widget.placeholder,
                                        style: TextStyleCustom.textRegular12
                                            .apply(
                                          color: widget.placeholderColor,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text:
                                                widget.isRequire ? ' *' : '',
                                            style:
                                                TextStyleCustom.textRegular12.apply(
                                                  color: colorE72D2D,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : const SizedBox(
                                    height: 10,
                                  );
                          },
                        ),
                      Stack(
                        children: [
                          Focus(
                            child: TextFormField(
                              focusNode: myFocusNode,
                              onTap: widget.onTap,
                              inputFormatters: widget.inputFormatters,
                              maxLength: widget.maxlengh,
                              keyboardType: widget.keyboardType,
                              onChanged: (value) {
                                widget.onChange?.call(
                                  widget.autoTrim ? value.trim() : value,
                                );
                              },
                              controller: _controller,
                              style: TextStyleCustom.textMedium16.apply(
                                color: widget.state == TextFieldState.DISABLED
                                    ? widget.disabledTextfieldColor
                                    : widget.textfieldColor,
                              ),
                              enabled:
                                  widget.state != TextFieldState.DISABLED,
                              cursorColor: widget.textfieldColor,
                              decoration: InputDecoration(
                                counterText: '',
                                hintStyle:
                                    TextStyleCustom.textRegular12.apply(
                                  color: widget.placeholderColor,
                                ),
                                isDense: true,
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                                filled: true,
                                fillColor:
                                    widget.state == TextFieldState.DISABLED
                                        ? widget.disabledBackground
                                        : widget.background,
                                errorStyle: const TextStyle(
                                  fontSize: 0,
                                  height: 0.7,
                                ),
                                // contentPadding: widget.contentPadding,
                              ),
                              obscuringCharacter: '*',
                              obscureText: widget.secureField,
                              validator: (value) {
                                final text = value ?? '';
                                errText = widget.validate?.call(
                                  widget.autoTrim ? text.trim() : text,
                                );
                                errTextSubject.wellAdd(errText);
                                return errText;
                              },
                            ),
                          ),
                          IgnorePointer(
                            child: StreamBuilder<bool>(
                              stream: hasStringSubject,
                              builder: (context, snapshot) {
                                final hasString = snapshot.data ?? false;
                                return hasString
                                    ? const SizedBox.shrink()
                                    : widget.placeholder != null
                                        ? RichText(
                                            text: TextSpan(
                                              text: widget.placeholder,
                                              style: TextStyleCustom
                                                  .textRegular12
                                                  .apply(
                                                color:
                                                    widget.placeholderColor,
                                              ),
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: widget.isRequire
                                                      ? ' *'
                                                      : '',
                                                  style: TextStyleCustom
                                                      .textRegular12
                                                      .apply(
                                                    color: colorE72D2D,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : const SizedBox.shrink();
                              },
                            ),
                          ),
                        ],
                      ),
                      StreamBuilder<bool>(
                        stream: hasStringSubject,
                        builder: (context, snapshot) {
                          final hasString = snapshot.data ?? false;
                          return hasString
                              ? const SizedBox.shrink()
                              : const SizedBox(
                                  height: 10,
                                );
                        },
                      ),
                    ],
                  ),
                ),
                widget.rightIcon ??
                    (widget.showClearIcon
                        ? StreamBuilder<bool>(
                            stream: hasStringSubject,
                            builder: (_, snapshot) {
                              final hasValue = snapshot.data ?? false;
                              if (!hasValue) {
                                return const SizedBox.shrink();
                              }
                              return ButtonCustom(
                                onPressed: () {
                                  _controller.clear();
                                  widget.onChange
                                      ?.call(_controller.value.text);
                                },
                                background: Colors.transparent,
                                rightIcon: ImageAssets.svgAssets(
                                  ImageAssets.ic_close,
                                  color: color717294,
                                ),
                              );
                            },
                          )
                        : const SizedBox.shrink()),
              ],
            ),
          ),
        ),
        StreamBuilder<String?>(
          stream: errTextSubject,
          builder: (context, snapshot) {
            final error = snapshot.data;
            if (error != null) {
              return Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(
                  left: widget.paddingErrorText,
                  right: widget.paddingErrorText,
                  top: 5,
                ),
                child: Text(
                  errText!,
                  style: TextStyleCustom.textRegular12.apply(
                    color: widget.errorHelperTextColor,
                  ),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ],
    );
  }
}

class ThousandsFormatter extends TextInputFormatter {
  static final NumberFormat _formatter = NumberFormat('#,##0', 'en_US');

  final FilteringTextInputFormatter _decimalFormatter;
  final String _decimalSeparator;
  final RegExp _decimalRegex;

  final NumberFormat? formatter;
  final bool allowFraction;

  ThousandsFormatter({this.formatter, this.allowFraction = false})
      : _decimalSeparator = (formatter ?? _formatter).symbols.DECIMAL_SEP,
        _decimalRegex = RegExp(
          allowFraction
              ? '[0-9]+([${(formatter ?? _formatter).symbols.DECIMAL_SEP}])?'
              : r'\d+',
        ),
        _decimalFormatter = FilteringTextInputFormatter.allow(
          RegExp(
            allowFraction
                ? '[0-9]+([${(formatter ?? _formatter).symbols.DECIMAL_SEP}])?'
                : r'\d',
          ),
        );
  TextEditingValue? _lastNewValue;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    /// nothing changes, nothing to do
    if (newValue.text == _lastNewValue?.text) {
      return newValue;
    }
    _lastNewValue = newValue;

    /// remove all invalid characters
    //ignore: parameter_assignments
    newValue = _formatValue(oldValue, newValue);

    /// current selection
    int selectionIndex = newValue.selection.end;

    /// format original string, this step would add some separator
    /// characters to original string
    final newText = _formatPattern(newValue.text);

    /// count number of inserted character in new string
    int insertCount = 0;

    /// count number of original input character in new string
    int inputCount = 0;
    for (int i = 0; i < newText.length && inputCount < selectionIndex; i++) {
      final character = newText[i];
      if (_isUserInput(character)) {
        inputCount++;
      } else {
        insertCount++;
      }
    }

    /// adjust selection according to number of inserted characters staying before
    /// selection
    selectionIndex += insertCount;
    selectionIndex = min(selectionIndex, newText.length);

    /// if selection is right after an inserted character, it should be moved
    /// backward, this adjustment prevents an issue that user cannot delete
    /// characters when cursor stands right after inserted characters
    if (selectionIndex - 1 >= 0 &&
        selectionIndex - 1 < newText.length &&
        !_isUserInput(newText[selectionIndex - 1])) {
      selectionIndex--;
    }

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: selectionIndex),
      composing: TextRange.empty,
    );
  }

  String _formatPattern(String digits) {
    if (digits.isEmpty) return digits;
    num number;
    if (allowFraction) {
      String decimalDigits = digits;
      if (_decimalSeparator != '.') {
        decimalDigits = digits.replaceFirst(RegExp(_decimalSeparator), '.');
      }
      number = double.tryParse(decimalDigits) ?? 0.0;
    } else {
      number = int.tryParse(digits) ?? 0;
    }
    final result = (formatter ?? _formatter).format(number);
    if (allowFraction && digits.endsWith(_decimalSeparator)) {
      return '$result$_decimalSeparator';
    }

    // Fix the .0 or .01 or .10 and similar issues
    if (digits.contains('.')) {
      final List<String> decimalPlacesValue = digits.split('.');
      final String decimalOnly = decimalPlacesValue[1];
      final double? digitsOnly = double.tryParse(decimalPlacesValue[0]);
      final String result = (formatter ?? _formatter).format(digitsOnly);
      if (decimalPlacesValue[0].length >= 13) {
        final newDigits = decimalPlacesValue[0].substring(0, 12);
        final double? digitsOnly = double.tryParse(newDigits);
        return '${(formatter ?? _formatter).format(digitsOnly)}.$decimalOnly';
      }
      if (decimalOnly.length >= 6) {
        return '$result.${decimalOnly.substring(0, 6)}';
      }
      return '$result.$decimalOnly';
    } else {
      if (digits.length >= 13) {
        final newDigits = digits.substring(0, 12);
        final double? digitsOnly = double.tryParse(newDigits);
        return (formatter ?? _formatter).format(digitsOnly);
      }
    }
    return result;
  }

  TextEditingValue _formatValue(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return _decimalFormatter.formatEditUpdate(oldValue, newValue);
  }

  bool _isUserInput(String s) {
    return s == _decimalSeparator || _decimalRegex.firstMatch(s) != null;
  }
}
