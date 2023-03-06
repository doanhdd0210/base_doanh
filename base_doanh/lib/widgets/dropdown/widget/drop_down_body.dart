import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:base_doanh/config/themes/app_theme.dart';
import 'package:base_doanh/widgets/dropdown/widget/drop_down_util.dart';


// ignore: must_be_immutable
class DropdownBody extends StatefulWidget {
  GlobalKey inputKey;
  late Function closeDropdown;
  late BuildContext bodyContext;
  late double screenHeight;
  LayerLink layerLink;

  List<dynamic> dropdownList;
  List<dynamic> dropdownIsSelected = [];
  Function onChange;
  Function getSelectedItem;
  bool isTriangle;
  bool isResultLabel;
  bool isDropdownLabel;
  late Map<dynamic, dynamic> selectedItem;
  late Widget dropdownIcon;
  Widget selectedIcon;
  bool isAnimation;

  // size
  int maxLines;
  double resultWidth;
  double resultHeight;
  double? dropdownWidth;
  double dropdownHeight;
  double dropdownItemHeight;
  double triangleWidth;
  double triangleHeight;

  // align
  Alignment resultAlign;
  String dropdownAlign;
  Alignment dropdownItemAlign;
  String triangleAlign;
  double triangleLeft;
  bool dropdownItemReverse;
  MainAxisAlignment dropdownItemMainAxis;

  // padding
  EdgeInsets dropdownItemPadding;
  EdgeInsets dropdownPadding;
  EdgeInsets selectedItemPadding;

  // style
  late BoxDecoration resultBD;
  late BoxDecoration dropdownBD;
  late BoxDecoration selectedItemBD;
  late BorderSide triangleBorder;
  late TextStyle selectedItemTS;
  late TextStyle unselectedItemTS;

  // gap
  double gap;
  double labelIconGap;
  double dropdownItemGap;
  double dropdownItemTopGap;
  double dropdownItemBottomGap;

  // triangleBox Shadow
  late List<dynamic> triangleBoxShadows;

  Function()? onBottomClick;
  String? bottomTitle;

  DropdownBody({
    Key? key,
    required this.inputKey,
    required this.dropdownList,
    required this.onChange,
    required this.closeDropdown,
    required this.getSelectedItem,
    required this.selectedItem,
    required this.dropdownItemReverse,
    required this.isTriangle,
    required this.resultWidth,
    required this.resultHeight,
    this.dropdownWidth,
    required this.maxLines,
    required this.dropdownHeight,
    required this.dropdownItemHeight,
    required this.resultAlign,
    required this.dropdownAlign,
    required this.triangleAlign,
    required this.dropdownItemAlign,
    required this.dropdownItemMainAxis,
    required this.dropdownItemPadding,
    required this.dropdownPadding,
    required this.selectedItemPadding,
    required this.resultBD,
    required this.dropdownBD,
    required this.selectedItemBD,
    required this.selectedItemTS,
    required this.unselectedItemTS,
    required this.labelIconGap,
    required this.dropdownItemGap,
    required this.dropdownItemTopGap,
    required this.dropdownItemBottomGap,
    required this.gap,
    required this.triangleWidth,
    required this.triangleHeight,
    required this.isAnimation,
    required this.isResultLabel,
    required this.selectedIcon,
    required this.bodyContext,
    required this.isDropdownLabel,
    required this.layerLink,
    // ignore: avoid_unused_constructor_parameters
    triangleBorder,
    required this.triangleLeft,
    this.bottomTitle,
    this.onBottomClick,
  }) : super(key: key) {
    // dropdown list 초기화
    for (var i = 0; i < dropdownList.length; i++) {
      dropdownIsSelected.add(false);
    }
    // 삼각형 border 셋팅
    this.triangleBorder = dropdownBD.border != null
        ? dropdownBD.border!.top
        : const BorderSide(
            color: Colors.transparent,
            width: 0,
            style: BorderStyle.none,
          );
    // 그림자 셋팅
    triangleBoxShadows = dropdownBD.boxShadow ?? [];
    // screenHeight 셋팅
    screenHeight = MediaQuery.of(bodyContext).size.height;
    // dropdownWidth setting
    dropdownWidth = dropdownWidth ?? resultWidth;
  }

  @override
  DropdownBodyState createState() => DropdownBodyState();
}

class DropdownBodyState extends State<DropdownBody>
    with TickerProviderStateMixin {
  // ignore: use_named_constants
  Offset dropdownOffset = const Offset(0, 0);

  // ignore: use_named_constants
  Offset triangleOffset = const Offset(0, 0);
  String selectedLabel = '';
  bool isOpen = false;
  bool isSelected = false;
  bool isTap = false;
  bool upsideDown = false;
  late bool isTop;
  final _scrollController = ScrollController();
  late AnimationController _animationController;
  late AnimationController _triangleController;
  final List<AnimationController> _dCController = [];
  final List<AnimationController> _paddingController = [];
  final List<Animation<EdgeInsets>> _paddingAnimation = [];
  late Animation<double> animateHeight;
  late Animation<double> triangleAnimation;

  late DecorationTween selectedDecorationTween;
  late TextStyleTween selectedTSTween;
  late EdgeInsetsTween selectedPaddingTween;
  late int currentIndex;
  AnimationUtil au = AnimationUtil();
  final GlobalKey globalKey = GlobalKey();

  @override
  void initState() {
    _animationController = AnimationController(
      duration: au.isAnimation(
        status: widget.isAnimation,
        duration: const Duration(milliseconds: 100),
      ),
      vsync: this,
    );
    selectedDecorationTween = DecorationTween(
      begin: const BoxDecoration(color: Colors.transparent),
      end: widget.selectedItemBD,
    );
    currentIndex = widget.dropdownList.indexWhere(
      (dropdownItem) => mapEquals(dropdownItem, widget.selectedItem),
    );

    setAnimation();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setOffset();
      setScrollPosition(currentIndex);
    });
  }

  void setOffset() {
    // inputBox info
    final dynamic inputBox = widget.inputKey.currentContext!.findRenderObject();
    // ignore: avoid_dynamic_calls
    final Offset inputPosition = inputBox!.localToGlobal(Offset.zero);

    final double actualBoxHeight = widget.dropdownHeight +
        widget.dropdownPadding.top +
        widget.dropdownPadding.bottom;
    final double inputCenterPosition =
        // ignore: avoid_dynamic_calls
        inputPosition.dy + (inputBox.size.height * 0.5);
    final double sidePadding =
        widget.dropdownPadding.right + widget.dropdownPadding.left;
    isTop = inputCenterPosition < widget.screenHeight * 0.5;

    if (isTop) {
      // position dropbox top
      dropdownOffset = setDropdownPosition(
        isTop: true,
        sidePadding: sidePadding,
        inputBox: inputBox,
        inputPosition: inputPosition,
        actualBoxHeight: actualBoxHeight,
      );
      triangleOffset = setTrianglePosition(
        dropdownOffset: dropdownOffset,
        sidePadding: sidePadding,
      );

      if (widget.screenHeight < actualBoxHeight + dropdownOffset.dy) {
        setState(() {
          widget.dropdownHeight = widget.screenHeight - dropdownOffset.dy - 10;
        });
      }
    } else {
      // position dropbox bottom
      dropdownOffset = setDropdownPosition(
        isTop: false,
        sidePadding: sidePadding,
        inputBox: inputBox,
        inputPosition: inputPosition,
        actualBoxHeight: actualBoxHeight,
      );
      final Offset bottomOffset = dropdownOffset +
          Offset(0, widget.dropdownHeight + widget.triangleHeight);
      triangleOffset = setTrianglePosition(
        dropdownOffset: bottomOffset,
        sidePadding: sidePadding,
      );
      setState(() {
        // triangle upsideDown
        upsideDown = true;
        final double extraHeight = widget.screenHeight -
            (widget.screenHeight - inputPosition.dy) -
            widget.gap -
            10;
        if (widget.dropdownHeight > extraHeight) {
          widget.dropdownHeight = extraHeight;
          dropdownOffset = Offset(dropdownOffset.dx, 10);
        }
      });
    }
  }

  void setAnimation() {
    // dropdown height

    _triangleController = AnimationController(
      duration: au.isAnimation(
        status: widget.isAnimation,
        duration: const Duration(milliseconds: 50),
      ),
      vsync: this,
    );
    final Animation<double> curve =
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
    animateHeight =
        Tween<double>(begin: 0, end: widget.dropdownHeight).animate(curve);
    triangleAnimation = CurvedAnimation(
      parent: _triangleController,
      curve: Curves.easeIn,
    );
    // each of items animation
    for (var i = 0; i < widget.dropdownIsSelected.length; i++) {
      final AnimationController animationControllerElement =
          AnimationController(
        vsync: this,
        duration: au.isAnimation(
          status: widget.isAnimation,
          duration: const Duration(
            milliseconds: 300,
          ),
        ),
      );
      _dCController.add(
        animationControllerElement,
      ); // selected, unselected decorationBox, textStyle
      _paddingController.add(animationControllerElement);
      _paddingAnimation.add(
        EdgeInsetsTween(
          begin: widget.dropdownItemPadding,
          end: widget.selectedItemPadding,
        ).animate(
          CurvedAnimation(parent: _paddingController[i], curve: Curves.easeIn),
        ),
      );
    }

    selectedTSTween = TextStyleTween(
      begin: widget.unselectedItemTS,
      end: widget.selectedItemTS,
    );
  }

  Future<void> setScrollPosition(int currentIndex) async {
    await animationForward();
    if (currentIndex != -1) {
      final double totalHeight = widget.dropdownList.length *
              (widget.dropdownItemHeight + widget.dropdownItemGap) +
          widget.dropdownItemTopGap +
          widget.dropdownItemBottomGap;
      double scrollPosition =
          currentIndex * (widget.dropdownItemHeight + widget.dropdownItemGap) +
              widget.dropdownItemTopGap -
              widget.dropdownItemGap;
      final double overScrollPosition =
          ((widget.dropdownItemHeight * widget.dropdownList.length) +
                  (widget.dropdownItemGap * (widget.dropdownList.length - 1)) +
                  widget.dropdownItemTopGap) -
              widget.dropdownHeight +
              widget.dropdownItemBottomGap;
      if (currentIndex == 0) {
        scrollPosition = 0;
      }
      if (overScrollPosition < scrollPosition) {
        scrollPosition = overScrollPosition;
      }
      if (totalHeight < widget.dropdownHeight) {
        scrollPosition = 0;
      }
      unawaited(
        _scrollController.animateTo(
          scrollPosition,
          duration: au.isAnimation(
            status: widget.isAnimation,
            duration: const Duration(milliseconds: 300),
          ),
          curve: Curves.easeInOut,
        ),
      );

      setState(() {
        widget.dropdownIsSelected[currentIndex] = true;
      });
      unawaited(_dCController[currentIndex].forward());
      unawaited(_paddingController[currentIndex].forward());
    }
  }

  Future<void> animationForward() async {
    if (isTop) {
      await _triangleController.forward();
      return _animationController.forward();
    } else {
      await _animationController.forward();
      return _triangleController.forward();
    }
  }

  Future<void> animationReverse() async {
    if (isTop) {
      await _animationController.reverse();
      return _triangleController.reverse();
    } else {
      await _triangleController.reverse();
      return _animationController.reverse();
    }
  }

  Offset setDropdownPosition({
    required bool isTop,
    required double sidePadding,
    required dynamic inputBox,
    required Offset inputPosition,
    required double actualBoxHeight,
  }) {
    double value = 0;

    switch (widget.dropdownAlign.toLowerCase()) {
      case 'left':
        value = 0;
        break;
      case 'right':
        // ignore: avoid_dynamic_calls
        value = inputBox.size.width -
            (widget.dropdownWidth! + sidePadding) -
            widget.triangleBorder.width * 2;
        break;
      case 'center':
        // ignore: avoid_dynamic_calls
        value = (inputBox.size.width - (widget.dropdownWidth! + sidePadding)) *
                0.5 -
            widget.triangleBorder.width;
        break;
      default:
        throw 'type of dropdownAlign has to be String.(right, left, center)';
    }
    return Offset(
      inputPosition.dx + value,
      isTop
          // ignore: avoid_dynamic_calls
          ? inputPosition.dy + inputBox.size.height + widget.gap
          : inputPosition.dy - (widget.gap + actualBoxHeight),
    );
  }

  Offset setTrianglePosition({
    required Offset dropdownOffset,
    required double sidePadding,
  }) {
    double value = 0;

    switch (widget.triangleAlign.toLowerCase()) {
      case 'left':
        value = widget.triangleBorder.width;
        break;
      case 'right':
        value = (widget.dropdownWidth! + sidePadding) -
            widget.triangleWidth -
            widget.triangleBorder.width;
        break;
      case 'center':
        value =
            (widget.dropdownWidth! + sidePadding - widget.triangleWidth) * 0.5 +
                widget.triangleBorder.width;
        break;
      default:
        throw 'type of triangleAlign has to be String.(right, left, center)';
    }

    return Offset(dropdownOffset.dx + value, dropdownOffset.dy);
  }

  void closeAnimation() {}

  @override
  Widget build(BuildContext context) {
    final RenderBox box =
        // ignore: cast_nullable_to_non_nullable
        widget.inputKey.currentContext?.findRenderObject() as RenderBox;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            GestureDetector(
              onPanDown: (_) async {
                await animationReverse();
                // ignore: avoid_dynamic_calls
                widget.closeDropdown();
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.transparent,
              ),
            ),
            // box
            CompositedTransformFollower(
              link: widget.layerLink,
              targetAnchor:
                  upsideDown ? Alignment.topCenter : Alignment.bottomCenter,
              followerAnchor:
                  upsideDown ? Alignment.bottomCenter : Alignment.topCenter,
              child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, snapshot) {
                    return Opacity(
                      opacity: _animationController.value,
                      child: Container(
                        decoration: widget.dropdownBD,
                        padding: widget.dropdownPadding,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ClipRRect(
                          borderRadius: widget.dropdownBD.borderRadius != null
                              // ignore: cast_nullable_to_non_nullable
                              ? widget.dropdownBD.borderRadius as BorderRadius
                              : BorderRadius.zero,
                          child: Opacity(
                            opacity: _animationController.value,
                            child: Container(
                              width: box.size.width,
                              // height: animateHeight.value,
                              constraints: BoxConstraints(
                                maxHeight: widget.dropdownHeight,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (widget.dropdownList.length > 4) Expanded(
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      physics: const ScrollPhysics(),
                                      shrinkWrap: true,
                                      controller: _scrollController,
                                      itemCount: widget.dropdownList.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Column(
                                          children: [
                                            if (index == 0)
                                              Container(
                                                height: widget.dropdownItemTopGap,
                                              ),
                                            GestureDetector(
                                              onTap: () async {
                                                setState(() {
                                                  isTap = true;
                                                  for (var i = 0;
                                                      i <
                                                          widget.dropdownList
                                                              .length;
                                                      i++) {
                                                    if (index == i) {
                                                      widget.dropdownIsSelected[
                                                          i] = true;
                                                    } else {
                                                      widget.dropdownIsSelected[
                                                          i] = false;
                                                    }
                                                  }
                                                });
                                                if (currentIndex != -1) {
                                                  if (currentIndex != index) {
                                                    unawaited(
                                                      _paddingController[
                                                              currentIndex]
                                                          .reverse(),
                                                    );
                                                    unawaited(
                                                      _paddingController[
                                                              currentIndex]
                                                          .reverse(),
                                                    );
                                                    unawaited(
                                                      _dCController[currentIndex]
                                                          .reverse(),
                                                    );
                                                  }
                                                }
                                                unawaited(
                                                  _paddingController[index]
                                                      .forward(),
                                                );
                                                await _dCController[index]
                                                    .forward();
                                                await animationReverse();
                                                // ignore: avoid_dynamic_calls
                                                widget.getSelectedItem(
                                                  widget.dropdownList[index],
                                                );
                                                widget.onChange(
                                                  widget.dropdownList[index],
                                                );
                                                widget.closeDropdown();
                                              },
                                              child: DecoratedBoxTransition(
                                                decoration:
                                                    selectedDecorationTween
                                                        .animate(
                                                            _dCController[index]),
                                                child: Container(
                                                  padding:
                                                      _paddingAnimation[index]
                                                          .value,
                                                  height:
                                                      widget.dropdownItemHeight,
                                                  child: Align(
                                                    alignment:
                                                        widget.dropdownItemAlign,
                                                    child: Row(
                                                      mainAxisAlignment: widget
                                                          .dropdownItemMainAxis,
                                                      children: [
                                                        if (widget
                                                            .isDropdownLabel)
                                                          DefaultTextStyleTransition(
                                                            style: selectedTSTween
                                                                .animate(
                                                              _dCController[
                                                                  index],
                                                            ),
                                                            child: Flexible(
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: Text(
                                                                      widget.dropdownList[
                                                                              index]
                                                                          [
                                                                          'label'],
                                                                      maxLines: widget
                                                                          .maxLines,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  ),
                                                                  if (index ==
                                                                      currentIndex)
                                                                    widget
                                                                        .selectedIcon
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                      ].isReverse(
                                                        widget
                                                            .dropdownItemReverse,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            if (index !=
                                                widget.dropdownList.length - 1)
                                              Container(
                                                height: widget.dropdownItemGap,
                                              ),
                                            if (index ==
                                                widget.dropdownList.length - 1)
                                              Container(
                                                height:
                                                    widget.dropdownItemBottomGap,
                                              )
                                          ],
                                        );
                                      },
                                    ),
                                  ) else ListView.builder(
                                    padding: EdgeInsets.zero,
                                    physics: const ScrollPhysics(),
                                    shrinkWrap: true,
                                    controller: _scrollController,
                                    itemCount: widget.dropdownList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Column(
                                        children: [
                                          if (index == 0)
                                            Container(
                                              height: widget.dropdownItemTopGap,
                                            ),
                                          GestureDetector(
                                            onTap: () async {
                                              setState(() {
                                                isTap = true;
                                                for (var i = 0;
                                                i <
                                                    widget.dropdownList
                                                        .length;
                                                i++) {
                                                  if (index == i) {
                                                    widget.dropdownIsSelected[
                                                    i] = true;
                                                  } else {
                                                    widget.dropdownIsSelected[
                                                    i] = false;
                                                  }
                                                }
                                              });
                                              if (currentIndex != -1) {
                                                if (currentIndex != index) {
                                                  unawaited(
                                                    _paddingController[
                                                    currentIndex]
                                                        .reverse(),
                                                  );
                                                  unawaited(
                                                    _paddingController[
                                                    currentIndex]
                                                        .reverse(),
                                                  );
                                                  unawaited(
                                                    _dCController[currentIndex]
                                                        .reverse(),
                                                  );
                                                }
                                              }
                                              unawaited(
                                                _paddingController[index]
                                                    .forward(),
                                              );
                                              await _dCController[index]
                                                  .forward();
                                              await animationReverse();
                                              // ignore: avoid_dynamic_calls
                                              widget.getSelectedItem(
                                                widget.dropdownList[index],
                                              );
                                              widget.onChange(
                                                widget.dropdownList[index],
                                              );
                                              widget.closeDropdown();
                                            },
                                            child: DecoratedBoxTransition(
                                              decoration:
                                              selectedDecorationTween
                                                  .animate(
                                                  _dCController[index]),
                                              child: Container(
                                                padding:
                                                _paddingAnimation[index]
                                                    .value,
                                                height:
                                                widget.dropdownItemHeight,
                                                child: Align(
                                                  alignment:
                                                  widget.dropdownItemAlign,
                                                  child: Row(
                                                    mainAxisAlignment: widget
                                                        .dropdownItemMainAxis,
                                                    children: [
                                                      if (widget
                                                          .isDropdownLabel)
                                                        DefaultTextStyleTransition(
                                                          style: selectedTSTween
                                                              .animate(
                                                            _dCController[
                                                            index],
                                                          ),
                                                          child: Flexible(
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                  child: Text(
                                                                    widget.dropdownList[
                                                                    index]
                                                                    [
                                                                    'label'],
                                                                    maxLines: widget
                                                                        .maxLines,
                                                                    overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                  ),
                                                                ),
                                                                if (index ==
                                                                    currentIndex)
                                                                  widget
                                                                      .selectedIcon
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                    ].isReverse(
                                                      widget
                                                          .dropdownItemReverse,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          if (index !=
                                              widget.dropdownList.length - 1)
                                            Container(
                                              height: widget.dropdownItemGap,
                                            ),
                                          if (index ==
                                              widget.dropdownList.length - 1)
                                            Container(
                                              height:
                                              widget.dropdownItemBottomGap,
                                            )
                                        ],
                                      );
                                    },
                                  ),
                                  if (widget.bottomTitle != null)
                                    GestureDetector(
                                      onTap: () {
                                        widget.closeDropdown();
                                        widget.onBottomClick?.call();
                                      },
                                      child: Container(
                                        width: double.maxFinite,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12,),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            top: BorderSide(
                                              color: AppTheme.getInstance().borderColor(),
                                            ),
                                          ),
                                        ),
                                        child:
                                            Text(widget.bottomTitle!),
                                      ),
                                    )
                                  else
                                    const SizedBox.shrink(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            // block box
            if (isTap)
              Positioned(
                top: dropdownOffset.dy,
                left: dropdownOffset.dx,
                child: Container(
                  width: widget.dropdownWidth! +
                      widget.dropdownPadding.right +
                      widget.dropdownPadding.left,
                  height: widget.dropdownHeight,
                  color: Colors.transparent,
                ),
              ),
            // triangle border
            if (widget.isTriangle)
              Positioned(
                top: upsideDown
                    ? triangleOffset.dy -
                        widget.triangleHeight +
                        widget.triangleBorder.width * 2
                    : triangleOffset.dy -
                        (widget.triangleHeight + widget.triangleBorder.width),
                left: triangleOffset.dx +
                    widget.triangleLeft -
                    (widget.triangleBorder.width / 2),
                child: SizeTransition(
                  sizeFactor: triangleAnimation,
                  axisAlignment: -1,
                  child: SizedBox(
                    width: widget.triangleWidth + widget.triangleBorder.width,
                    height: widget.triangleHeight + widget.triangleBorder.width,
                    child: CustomPaint(
                      painter: TrianglePainter(
                        strokeColor: widget.triangleBorder.color,
                        strokeWidth: 1,
                        paintingStyle: PaintingStyle.fill,
                        upsideDown: upsideDown,
                      ),
                    ),
                  ),
                ),
              ),
            // triangle
            if (widget.isTriangle)
              Positioned(
                top: upsideDown
                    ? triangleOffset.dy -
                        widget.triangleHeight +
                        widget.triangleBorder.width -
                        0.5
                    : triangleOffset.dy -
                        widget.triangleHeight +
                        widget.triangleBorder.width +
                        0.5,
                left: triangleOffset.dx + widget.triangleLeft,
                child: SizeTransition(
                  sizeFactor: triangleAnimation,
                  axisAlignment: -1,
                  child: SizedBox(
                    width: widget.triangleWidth,
                    height: widget.triangleHeight,
                    child: CustomPaint(
                      painter: TrianglePainter(
                        // ignore: cast_nullable_to_non_nullable
                        strokeColor: widget.dropdownBD.color as Color,
                        strokeWidth: 1,
                        paintingStyle: PaintingStyle.fill,
                        upsideDown: upsideDown,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;
  final double blurRadius;
  final bool upsideDown;

  TrianglePainter({
    this.strokeColor = Colors.black,
    this.strokeWidth = 0,
    this.paintingStyle = PaintingStyle.stroke,
    this.blurRadius = 0,
    this.upsideDown = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = paintingStyle;

    if (blurRadius != 0) {
      paint.maskFilter = MaskFilter.blur(BlurStyle.normal, blurRadius);
    }
    canvas.drawPath(getTrianglePath(size.width, size.height), paint);
  }

  Path getTrianglePath(double x, double y) {
    if (upsideDown) {
      return Path()
        ..moveTo(0, 0)
        ..lineTo(x / 2, y)
        ..lineTo(x, 0)
        ..lineTo(0, 0);
    } else {
      return Path()
        ..moveTo(0, y)
        ..lineTo(x / 2, 0)
        ..lineTo(x, y)
        ..lineTo(0, y);
    }
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) {
    return oldDelegate.strokeColor != strokeColor ||
        oldDelegate.paintingStyle != paintingStyle ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
