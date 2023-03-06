import 'package:flutter/material.dart';

class ExpandWidget extends StatefulWidget {
  final bool initExpand;
  final Widget header;
  final Widget child;
  final Function(bool)? onchange;

  const ExpandWidget({
    Key? key,
    this.initExpand = false,
    required this.child,
    required this.header,
    this.onchange,
  }) : super(key: key);

  @override
  ExpandedSectionState createState() => ExpandedSectionState();
}

class ExpandedSectionState extends State<ExpandWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController expandController;
  late Animation<double> animation;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
  }

  void prepareAnimations() {
    isExpanded = widget.initExpand;
    expandController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..value = widget.initExpand ? 1 : 0;
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.linear,
    );
  }

  void runExpandCheck() {
    if (isExpanded) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void didUpdateWidget(ExpandWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    runExpandCheck();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            isExpanded = !isExpanded;
            runExpandCheck();
            if (expandController.value == 0) {
              widget.onchange?.call(true);
            } else {
              widget.onchange?.call(false);
            }
          },
          child: widget.header,
        ),
        SizeTransition(
          axisAlignment: 1.0,
          sizeFactor: animation,
          child: widget.child,
        ),
      ],
    );
  }
}
