import 'package:flutter/material.dart';
import 'package:base_doanh/utils/style_utils.dart';

class CheckBox extends StatefulWidget {
  final Widget child;
  final Function(bool) onTap;
  final bool selectCheck;
  final bool isCircle;

  const CheckBox({
    Key? key,
    required this.child,
    required this.onTap,
    this.selectCheck = false,
    this.isCircle = false,
  }) : super(key: key);

  @override
  State<CheckBox> createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {
  bool selectCheck = false;

  @override
  void initState() {
    selectCheck = widget.selectCheck;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // setState(() {
        //   selectCheck = !selectCheck;
        //   widget.onTap(selectCheck);
        // });
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 16,
            width: 16,
            child: Checkbox(
              splashRadius: 4,
              activeColor: Colors.red,
              checkColor: Colors.white,
              value: selectCheck,
              onChanged: (select) {
                setState(() {
                  selectCheck = !selectCheck;
                  widget.onTap(selectCheck);
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular( widget.isCircle ? 30 :4),
              ),
            ),
          ),
          spaceW16,
          Expanded(
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
