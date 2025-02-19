import 'package:flutter/material.dart';
import 'package:hapycar/config/themes/app_theme.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

enum Indicator {
  ballPulse,
  ballGridPulse,
  ballClipRotate,
  squareSpin,
  ballClipRotatePulse,
  ballClipRotateMultiple,
  ballPulseRise,
  ballRotate,
  cubeTransition,
  ballZigZag,
  ballZigZagDeflect,
  ballTrianglePath,
  ballTrianglePathColored,
  ballTrianglePathColoredFilled,
  ballScale,
  lineScale,
  lineScaleParty,
  ballScaleMultiple,
  ballPulseSync,
  ballBeat,
  lineScalePulseOut,
  lineScalePulseOutRapid,
  ballScaleRipple,
  ballScaleRippleMultiple,
  ballSpinFadeLoader,
  lineSpinFadeLoader,
  triangleSkewSpin,
  pacman,
  ballGridBeat,
  semiCircleSpin,
  ballRotateChase,
  orbit,
  audioEqualizer,
  circleStrokeSpin,
}

class CupertinoLoading extends StatelessWidget {
  const CupertinoLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.waveDots(
      size: 42,
      color: AppTheme.getInstance().colorOrange(),
    );
  }
}

List<Color> getListColor() {
  final colors = <Color>[
    AppTheme.getInstance().colorOrange(),
    AppTheme.getInstance().colorOrange().withOpacity(0.9),
    AppTheme.getInstance().colorOrange().withOpacity(0.8),
    AppTheme.getInstance().colorOrange().withOpacity(0.7),
    AppTheme.getInstance().colorOrange().withOpacity(0.6),
    AppTheme.getInstance().colorOrange().withOpacity(0.5),
    AppTheme.getInstance().colorOrange(),
  ];
  return colors;
}
