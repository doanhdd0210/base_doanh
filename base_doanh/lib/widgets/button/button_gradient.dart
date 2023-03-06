import 'package:flutter/material.dart';

class ButtonGradient extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final Function onPressed;

  const ButtonGradient({
    Key? key,
    required this.child,
    required this.gradient,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 52.0,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: const BorderRadius.all(Radius.circular(26.0)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            onPressed();
          },
          child: Center(
            child: child,
          ),
        ),
      ),
    );
  }
}
