import 'package:flutter/material.dart';
import 'package:hapycar/widgets/dialog/decorate_app.dart';

const double _kMinIndicatorSize = 24.0;

// This is indicator length
// should be = 1/6 * CupertinoLoading size
const double _kDefaultIndicatorRadius = 13.3;

/// Basic shape.
enum Shape {
  circle,
  ringThirdFour,
  rectangle,
  ringTwoHalfVertical,
  ring,
  line,
  triangle,
  arc,
  circleSemi,
}

/// Wrapper class for basic shape.
class IndicatorShapeWidget extends StatelessWidget {
  final Shape shape;
  final double? data;

  /// The index of shape in the widget.
  final int index;

  const IndicatorShapeWidget({
    Key? key,
    required this.shape,
    this.data,
    this.index = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DecorateData decorateData = DecorateContext.of(context)!.decorateData;
    final color = decorateData.colors[index % decorateData.colors.length];

    return Container(
      constraints: const BoxConstraints(
        minWidth: _kMinIndicatorSize,
        minHeight: _kMinIndicatorSize,
      ),
      child: CustomPaint(
        painter: _ShapePainter(
          color,
          shape,
          data,
          decorateData.strokeWidth,
          pathColor: decorateData.pathBackgroundColor,
        ),
      ),
    );
  }
}

class _ShapePainter extends CustomPainter {
  final Color color;
  final Shape shape;
  final Paint _paint;
  final double? data;
  final double strokeWidth;
  final Color? pathColor;

  _ShapePainter(
    this.color,
    this.shape,
    this.data,
    this.strokeWidth, {
    this.pathColor,
  })  : _paint = Paint()..isAntiAlias = true,
        super();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(size.width / 2.0, size.height / 2.0);
    _paint.color = color;
    canvas.drawRRect(
        RRect.fromLTRBXY(
          -strokeWidth / 2, // left
          -_kDefaultIndicatorRadius / 3.0, // top
          strokeWidth / 2, // right
          -_kDefaultIndicatorRadius, // bottom
          strokeWidth / 2, // radX
          strokeWidth / 2, // radY
        ),
        _paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_ShapePainter oldDelegate) =>
      shape != oldDelegate.shape ||
      color != oldDelegate.color ||
      data != oldDelegate.data ||
      strokeWidth != oldDelegate.strokeWidth ||
      pathColor != oldDelegate.pathColor;
}
