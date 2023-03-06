import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:base_doanh/utils/constants/image_asset.dart';

import 'copertino_picker_custom.dart';

class CupertinoSelector extends StatefulWidget {
  const CupertinoSelector({
    Key? key,
    required this.itemBuilder,
    this.kItemExtent = 80,
    this.scrollDirection = Axis.horizontal,
    this.kSqueeze = 1.1,
    this.kDiameterRatio = 10,
    this.width = 130,
    this.scaleSelectedItem = 1.9,
    required this.onSelectedItemChanged,
    required this.itemCount,
  }) : super(key: key);
  final Widget Function(int index) itemBuilder;
  final Function(int) onSelectedItemChanged;
  final int itemCount;
  final double kItemExtent;
  final double kSqueeze;
  final double kDiameterRatio;
  final double width;
  final Axis scrollDirection;
  final double scaleSelectedItem;

  @override
  State<CupertinoSelector> createState() => _CupertinoSelectorState();
}

class _CupertinoSelectorState extends State<CupertinoSelector> {
  late FixedExtentScrollController controller;
  int selectItem = 0;

  @override
  void initState() {
    controller = FixedExtentScrollController(initialItem: widget.itemCount);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: widget.scrollDirection == Axis.horizontal ? 1 : 0,
      child: Center(
        child: SizedBox(
          width: widget.width,
          height: MediaQuery.of(context).size.width,
          child: Center(
            child: GestureDetector(
              onTapDown: (detail) {
                final height =
                    (context.findRenderObject() as RenderBox?)?.size.width ?? 0;
                double indexChange = ((height / 2) - detail.localPosition.dy) /
                    widget.kItemExtent;
                if (detail.localPosition.dy <=
                        (height / 2) + widget.kItemExtent / 2 &&
                    detail.localPosition.dy >=
                        (height / 2) - widget.kItemExtent / 2) {
                  indexChange = 0;
                }
                controller.animateToItem(
                  selectItem -
                      (indexChange < 0
                          ? indexChange.floor()
                          : indexChange.ceil()),
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.decelerate,
                );
              },
              child: CupertinoPickerCustom(
                scrollController: controller,
                itemExtent: widget.kItemExtent,
                squeeze: widget.kSqueeze,
                looping: true,
                diameterRatio: widget.kDiameterRatio,
                onSelectedItemChanged: (index) {
                  setState(() {
                    selectItem = index;
                  });
                  widget.onSelectedItemChanged(index);
                },
                selectionOverlay: Row(
                  children: [
                    Transform.rotate(
                      angle: -pi / 2,
                      child: SvgPicture.asset(
                        ImageAssets.ic_dropdown,
                        height: 12,
                        width: 16,
                      ),
                    ),
                    const Expanded(
                      child: SizedBox.expand(),
                    ),
                    Transform.rotate(
                      angle: pi / 2,
                      child: SvgPicture.asset(
                        ImageAssets.ic_dropdown,
                        height: 12,
                        width: 16,
                      ),
                    ),
                  ],
                ),
                children: List.generate(
                  widget.itemCount,
                  (index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: index == selectItem ? 20 : 0,
                      ),
                      child: Transform.scale(
                        scale: index == selectItem
                            ? widget.scaleSelectedItem
                            : 1,
                        child: Transform.rotate(
                          angle: -pi / 2,
                          child: widget.itemBuilder(index),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
