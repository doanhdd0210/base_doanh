library cool_dropdown;

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:base_doanh/config/base/rx.dart';
import 'package:base_doanh/config/resources/color.dart';
import 'package:base_doanh/utils/constants/image_asset.dart';
import 'package:base_doanh/widgets/button/button_custom.dart';
import 'package:base_doanh/widgets/dropdown/widget/drop_down_body.dart';
import 'package:base_doanh/widgets/dropdown/widget/drop_down_util.dart';
import 'package:base_doanh/widgets/textformfield/textfield_custom.dart';
// ignore: must_be_immutable
class CoolDropdown extends StatefulWidget {
  List<dynamic> dropdownList;
  Function onChange;
  Function? onOpen;
  String placeholder;
  late Map<dynamic, dynamic> defaultValue;
  bool isTriangle;
  bool isAnimation;
  int maxLines;
  bool isResultIconLabel;
  bool isResultLabel;
  bool isDropdownLabel; // late
  bool resultIconRotation;
  late Widget resultIcon;
  Widget? selectedIcon;
  double resultIconRotationValue;

  // size
  double resultWidth;
  double resultHeight;
  double? dropdownWidth; // late
  double dropdownHeight; // late
  double dropdownItemHeight;
  double triangleWidth;
  double triangleHeight;
  double iconSize;

  // align
  Alignment resultAlign;
  String dropdownAlign; // late
  Alignment dropdownItemAlign;
  String triangleAlign;
  double triangleLeft;
  bool dropdownItemReverse;
  bool resultReverse;
  MainAxisAlignment resultMainAxis;
  MainAxisAlignment dropdownItemMainAxis;

  // padding
  EdgeInsets resultPadding;
  EdgeInsets dropdownItemPadding;
  EdgeInsets dropdownPadding; // late
  EdgeInsets selectedItemPadding;

  // style
  late BoxDecoration resultBD;
  late BoxDecoration dropdownBD; // late
  late BoxDecoration selectedItemBD;
  late TextStyle selectedItemTS;
  late TextStyle unselectedItemTS;
  late TextStyle resultTS;
  late TextStyle placeholderTS;

  // gap
  double gap;
  double labelIconGap;
  double dropdownItemGap;
  double dropdownItemTopGap;
  double dropdownItemBottomGap;
  double resultIconLeftGap;

  //controller
  final TextEditingController? controller;
  final EdgeInsets? contentPadding;
  final Function(String)? validate;
  bool isActionWidget;
  Function()? onBottomClick;
  String? bottomTitle;
  bool isRequire;
  bool alwayReInit;

  CoolDropdown({
    Key? key,
    required this.dropdownList,
    required this.onChange,
    this.onOpen,
    placeholderTS,
    this.selectedIcon,
    this.dropdownItemReverse = false,
    this.resultReverse = false,
    required this.maxLines,
    this.resultIconRotation = true,
    this.isTriangle = true,
    this.isResultLabel = true,
    this.placeholder = '',
    this.resultWidth = 220,
    this.resultHeight = 50,
    this.dropdownWidth,
    this.dropdownHeight = 300,
    this.dropdownItemHeight = 50,
    this.resultAlign = Alignment.centerLeft,
    this.dropdownAlign = 'center',
    this.triangleAlign = 'center',
    this.dropdownItemAlign = Alignment.centerLeft,
    this.dropdownItemMainAxis = MainAxisAlignment.spaceBetween,
    this.resultMainAxis = MainAxisAlignment.spaceBetween,
    this.resultPadding = const EdgeInsets.only(left: 10, right: 10),
    this.dropdownItemPadding = const EdgeInsets.only(left: 10, right: 10),
    this.dropdownPadding = const EdgeInsets.only(left: 10, right: 10),
    this.selectedItemPadding = const EdgeInsets.only(left: 10, right: 10),
    resultBD,
    dropdownBD,
    selectedItemBD,
    selectedItemTS,
    unselectedItemTS,
    resultTS,
    this.labelIconGap = 10,
    this.dropdownItemGap = 5,
    this.dropdownItemTopGap = 10,
    this.dropdownItemBottomGap = 10,
    this.resultIconLeftGap = 10,
    this.gap = 30,
    this.triangleWidth = 20,
    this.triangleHeight = 20,
    this.triangleLeft = 0,
    this.isAnimation = true,
    this.isResultIconLabel = true,
    this.resultIconRotationValue = 0.5,
    this.isDropdownLabel = true,
    this.iconSize = 10,
    defaultValue,
    this.controller,
    this.contentPadding,
    this.validate,
    this.isActionWidget = false,
    this.bottomTitle,
    this.onBottomClick,
    this.isRequire = false,
    this.alwayReInit = false,
  }) : super(key: key) {
    // 기본값 셋팅
    if (defaultValue != null) {
      this.defaultValue = defaultValue;
    } else {
      this.defaultValue = {};
    }
    // box decoration 셋팅
    this.resultBD = resultBD ??
        BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ],
        );
    this.dropdownBD = dropdownBD ??
        BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 1),
            ),
          ],
        );
    this.selectedItemBD = selectedItemBD ??
        BoxDecoration(
          color: const Color(0XFFEFFAF0),
          borderRadius: BorderRadius.circular(10),
        );
    // text style 셋팅
    this.selectedItemTS = selectedItemTS ??
        const TextStyle(color: Color(0xFF6FCC76), fontSize: 20);
    this.unselectedItemTS = unselectedItemTS ??
        const TextStyle(
          fontSize: 20,
          color: Colors.black,
        );
    this.resultTS = resultTS ??
        const TextStyle(
          fontSize: 20,
          color: Colors.black,
        );
    this.placeholderTS = placeholderTS ??
        TextStyle(color: Colors.grey.withOpacity(0.7), fontSize: 20);
  }

  @override
  _CoolDropdownState createState() => _CoolDropdownState();
}

class _CoolDropdownState extends State<CoolDropdown>
    with TickerProviderStateMixin {
  GlobalKey<DropdownBodyState> dropdownBodyChild = GlobalKey();
  LayerLink layerLink = LayerLink();
  GlobalKey inputKey = GlobalKey();
  BehaviorSubject<bool> isOpenSubject = BehaviorSubject.seeded(false);

  // ignore: use_named_constants
  Offset triangleOffset = const Offset(0, 0);
  late OverlayEntry _overlayEntry;
  late Map<dynamic, dynamic> selectedItem;
  late AnimationController rotationController;
  late AnimationController sizeController;
  late Animation<double> textWidth;
  AnimationUtil au = AnimationUtil();
  late bool isOpen = false;

  void openDropdown() {
    isOpen = true;
    isOpenSubject.wellAdd(true);
    widget.onOpen?.call(isOpen);
    _overlayEntry = _createOverlayEntry();
    FocusScope.of(context).unfocus();
    Overlay.of(inputKey.currentContext!).insert(_overlayEntry);
    rotationController.forward();
  }

  void closeDropdown() {
    isOpen = false;
    isOpenSubject.wellAdd(false);
    widget.onOpen?.call(isOpen);
    _overlayEntry.remove();
    rotationController.reverse();
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (BuildContext context) => DropdownBody(
        layerLink: layerLink,
        selectedIcon: widget.selectedIcon ?? const SizedBox.shrink(),
        key: dropdownBodyChild,
        inputKey: inputKey,
        onChange: widget.onChange,
        maxLines: widget.maxLines,
        dropdownList: widget.dropdownList,
        dropdownItemReverse: widget.dropdownItemReverse,
        isTriangle: widget.isTriangle,
        resultWidth: widget.resultWidth,
        resultHeight: widget.resultHeight,
        dropdownWidth: widget.dropdownWidth,
        dropdownHeight: widget.dropdownHeight,
        dropdownItemHeight: widget.dropdownItemHeight,
        resultAlign: widget.resultAlign,
        dropdownAlign: widget.dropdownAlign,
        triangleAlign: widget.triangleAlign,
        dropdownItemAlign: widget.dropdownItemAlign,
        dropdownItemPadding: widget.dropdownItemPadding,
        dropdownPadding: widget.dropdownPadding,
        selectedItemPadding: widget.selectedItemPadding,
        resultBD: widget.resultBD,
        dropdownBD: widget.dropdownBD,
        selectedItemBD: widget.selectedItemBD,
        selectedItemTS: widget.selectedItemTS,
        unselectedItemTS: widget.unselectedItemTS,
        dropdownItemGap: widget.dropdownItemGap,
        dropdownItemTopGap: widget.dropdownItemTopGap,
        dropdownItemBottomGap: widget.dropdownItemBottomGap,
        gap: widget.gap,
        labelIconGap: widget.labelIconGap,
        triangleWidth: widget.triangleWidth,
        triangleHeight: widget.triangleHeight,
        triangleLeft: widget.triangleLeft,
        isResultLabel: widget.isResultLabel,
        bottomTitle: widget.bottomTitle,
        onBottomClick: widget.onBottomClick,
        closeDropdown: () {
          closeDropdown();
        },
        getSelectedItem: (selectedItem) async {
          sizeController = AnimationController(
            vsync: this,
            duration: au.isAnimation(
              status: widget.isAnimation,
              duration: const Duration(milliseconds: 150),
            ),
          );
          textWidth = CurvedAnimation(
            parent: sizeController,
            curve: Curves.fastOutSlowIn,
          );
          setState(() {
            this.selectedItem = selectedItem;
            _controller.text = selectedItem['value'];
          });
          await sizeController.forward();
        },
        selectedItem: selectedItem,
        isAnimation: widget.isAnimation,
        dropdownItemMainAxis: widget.dropdownItemMainAxis,
        bodyContext: context,
        isDropdownLabel: widget.isDropdownLabel,
      ),
    );
  }

  late final TextEditingController _controller;

  @override
  void initState() {
    rotationController = AnimationController(
      duration: au.isAnimation(
        status: widget.isAnimation,
        duration: const Duration(milliseconds: 150),
      ),
      vsync: this,
    );
    sizeController = AnimationController(
      vsync: this,
      duration: au.isAnimation(
        status: widget.isAnimation,
        duration: const Duration(milliseconds: 150),
      ),
    );
    textWidth = CurvedAnimation(
      parent: sizeController,
      curve: Curves.fastOutSlowIn,
    );
    // placeholder 셋팅
    _controller = widget.controller ?? TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => setDefaultValue(),
    );
    super.initState();
  }

  void setDefaultValue() {
    setState(() {
      selectedItem = widget.defaultValue;
      if (selectedItem['value'] != null) {
        _controller.text = selectedItem['value'];
      }else {
        _controller.text = '';
      }
      sizeController = AnimationController(
        vsync: this,
        duration: au.isAnimation(status: false),
      );
      textWidth = CurvedAnimation(
        parent: sizeController,
        curve: Curves.fastOutSlowIn,
      );
      sizeController.forward();
    });
  }

  RotationTransition rotationIcon() {
    return RotationTransition(
      turns: Tween(begin: 0.0, end: widget.resultIconRotationValue).animate(
        CurvedAnimation(parent: rotationController, curve: Curves.easeIn),
      ),
      child: widget.resultIcon,
    );
  }

  @override
  void didUpdateWidget(covariant CoolDropdown oldWidget) {
    if(widget.alwayReInit) {
      setDefaultValue();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isOpen) {
          await dropdownBodyChild.currentState!.animationReverse();
          closeDropdown();
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: GestureDetector(
        onTap: () {
          openDropdown();
        },
        child: CompositedTransformTarget(
          link: layerLink,
          child: StreamBuilder<bool>(
            stream: isOpenSubject,
            builder: (context, snapshot) {
              final bool isOpen = snapshot.data ?? false;
              return !widget.isActionWidget
                  ? TextFieldCustom(
                      isRequire: widget.isRequire,
                      isDropdown: true,
                      textEditingController: _controller,
                      key: inputKey,
                      placeholder: widget.placeholder,
                      disabledBackground: Colors.white,
                      borderDisabledColor: isOpen
                          ? color13BC78
                          : colorF0EEEE,
                      state: TextFieldState.DISABLED,
                      rightIcon: Align(
                        alignment: Alignment.bottomRight,
                        child: ImageAssets.svgAssets(
                          ImageAssets.icSuccess,
                        ),
                      ),
                      contentPadding: widget.contentPadding,
                      validate: (value) {
                        return widget.validate?.call(value);
                      },
                    )
                  : ButtonCustom(
                      onPressed: () {
                        openDropdown();
                      },
                      horizontalAlignment: MainAxisAlignment.spaceBetween,
                      background: Colors.transparent,
                      foregroundColor: color433F63,
                      text: _controller.value.text,
                      key: inputKey,

                      rightIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ImageAssets.svgAssets(
                          ImageAssets.icSuccess,
                          width: 13,
                          height: 7,
                          fit: BoxFit.cover,
                          color: color433F63,
                        ),
                      ),
                      type: ButtonType.SECONDARY,
                      size: ButtonSize.SMALL,
                    );
            },
          ),
        ),
      ),
    );
  }
}

