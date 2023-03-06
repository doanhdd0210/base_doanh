import 'package:flutter/cupertino.dart';

class AnimationUtil {
  Duration disable = Duration.zero;

  Duration isAnimation({
    required bool status,
    Duration duration = Duration.zero,
  }) {
    if (status) {
      return duration;
    } else {
      return disable;
    }
  }
}

extension ReverseList on List<Widget> {
  List<Widget> isReverse(bool isReverse) {
    if (isReverse) {
      return reversed.toList();
    } else {
      return this;
    }
  }
}
