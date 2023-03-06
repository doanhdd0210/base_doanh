import 'package:flutter/material.dart';
import 'package:base_doanh/config/resources/color.dart';
import 'package:base_doanh/config/resources/styles.dart';
import 'package:base_doanh/widgets/dropdown/widget/cool_drop_down_custom.dart';

class DropDownCustom extends StatefulWidget {
  final String placeholder;
  final String initData;
  final Function(int) onChange;
  final List<String> listData;
  final List<String>? icons;
  final double? setWidth;
  final int maxLines;
  final bool showSelectedDecoration;
  final bool useCustomHintColors;
  final Widget? selectedIcon;
  final bool needReInitData;
  final double? fontSize;
  final TextEditingController? controller;
  final EdgeInsets? contentPadding;
  final Function(String)? validate;
  final bool isActionWidget;
  final Function()? onBottomClick;
  final String? bottomTitle;
  final bool isRequire;
  final bool alwaysReInit;

  const DropDownCustom({
    Key? key,
    this.placeholder = '',
    required this.onChange,
    required this.listData,
    this.initData = '',
    this.setWidth,
    this.maxLines = 1,
    this.showSelectedDecoration = true,
    this.selectedIcon,
    this.useCustomHintColors = false,
    this.needReInitData = false,
    this.fontSize,
    this.controller,
    this.contentPadding,
    this.icons,
    this.validate,
    this.isActionWidget = false,
    this.bottomTitle,
    this.onBottomClick,
    this.isRequire = false,
    this.alwaysReInit = false,
  }) : super(key: key);

  @override
  _DropDownCustomState createState() => _DropDownCustomState();
}

class _DropDownCustomState extends State<DropDownCustom> {
  final List<Map<dynamic, dynamic>> listSelect = [];
  int initIndex = -1;

  @override
  void initState() {
    super.initState();
    initValue();
  }

  @override
  void didUpdateWidget(covariant DropDownCustom oldWidget) {
    if(widget.alwaysReInit) {
      initValue();
    }else if (widget.needReInitData && listSelect.isEmpty) {
      initValue();
    }
    super.didUpdateWidget(oldWidget);
  }

  void initValue() {
    listSelect.clear();
    initIndex = -1;
    for (var i = 0; i < widget.listData.length; i++) {
      listSelect.add({
        'label': widget.listData[i],
        'value': widget.listData[i],
      });
    }
    initIndex = widget.listData.indexOf(widget.initData);
    if (initIndex >= 0) {
      widget.onChange(initIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CoolDropdown(
      controller: widget.controller,
      maxLines: widget.maxLines,
      isRequire: widget.isRequire,
      defaultValue: initIndex < 0 ? null : listSelect[initIndex],
      resultAlign: Alignment.center,
      dropdownList: listSelect,
      alwayReInit: widget.alwaysReInit,
      onChange: (value) {
        widget.onChange(listSelect.indexOf(value));
      },
      placeholder: widget.placeholder,
      selectedItemTS: TextStyleCustom.textRegular14.copyWith(
        color: colorTextTitle,
      ),
      unselectedItemTS: TextStyleCustom.textRegular14.copyWith(
        color: colorTextTitle,
      ),
      selectedItemBD: const BoxDecoration(
        color: colorF0FDF6,
      ),
      selectedIcon: widget.selectedIcon,
      dropdownBD: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: color5875AC.withOpacity(
              0.08,
            ),
            offset: const Offset(0, 4),
            blurRadius: 56,
          ),
          BoxShadow(
            color: color5875AC.withOpacity(
              0.08,
            ),
            offset: const Offset(0, 12),
            blurRadius: 16,
          )
        ],
      ),
      dropdownPadding: EdgeInsets.zero,
      isTriangle: false,
      gap: 1.0,
      contentPadding: widget.contentPadding,
      validate: widget.validate,
      isActionWidget: widget.isActionWidget,
      bottomTitle: widget.bottomTitle,
      onBottomClick: widget.onBottomClick,
      // resultWidth: 800,
    );
  }
}
