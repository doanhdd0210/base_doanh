import 'package:flutter/material.dart';
import 'package:base_doanh/widgets/dialog/decorate_app.dart';
import 'package:base_doanh/widgets/dialog/line_spin_fade_loader.dart';

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
    return SizedBox(
      width: 80,
      height: 80,
      child: DecorateContext(
        decorateData: DecorateData(
            indicator: Indicator.lineSpinFadeLoader,
            colors: getListColor(),
            strokeWidth: 4),
        child: const AspectRatio(
          aspectRatio: 1,
          child: LineSpinFadeLoader(),
        ),
      ),
    );
  }
}

List<Color> getListColor() {
  final colors = <Color>[
    const Color(0xffFF4044),
    const Color(0xffff4a51),
    const Color(0xffff545e),
    const Color(0xffff5e6b),
    const Color(0xffff6878),
    const Color(0xffff7285),
    const Color(0xffff7c92),
    const Color(0xffff869f),
    const Color(0xffff90ad),
    const Color(0xffffa4c1),
    const Color(0xffff2828),
    const Color(0xffff3637),
  ];
  return colors;
}
