import 'package:flutter/material.dart';
import '../models/enum_type.dart';

/// [ModalBarrierLayout] use to customize [ModalBarrier]
///
class ModalBarrierAnimated extends AnimatedWidget {
  /// Available when [barrierShape] is [BarrierShape.headerTrans]
  ///
  /// Support not set [barrierColor] at header
  final RelativeRect position;

  /// The color to use for the modal barrier.
  /// If non-null, fill the barrier with this color.
  ///
  /// See also:
  ///
  ///  * [ModalRoute.barrierColor], which controls this property for the
  ///    [AnimatedModalBarrier] built by [ModalRoute] pages.
  Animation<Color?> get color => listenable as Animation<Color?>;

  /// [BarrierShape.normal] or [BarrierShape.headerTrans]
  final BarrierShape? barrierShape;

  const ModalBarrierAnimated({
    Key? key,
    required this.position,
    required Animation<Color?> color,
    this.barrierShape,
  }) : super(key: key, listenable: color);

  @override
  Widget build(BuildContext context) {
    return ModalBarrierLayout(
      position: position,
      barrierColor: color.value,
      barrierShape: barrierShape,
    );
  }
}

class ModalBarrierLayout extends StatelessWidget {
  /// Available when [barrierShape] is [BarrierShape.headerTrans]
  ///
  /// Support not set [barrierColor] at header
  final RelativeRect position;

   /// The color to use for the modal barrier.
  final Color? barrierColor;

  /// [BarrierShape.normal] or [BarrierShape.headerTrans]
  final BarrierShape? barrierShape;

  const ModalBarrierLayout({
    super.key,
    required this.position,
    required this.barrierColor,
    this.barrierShape,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.of(context).pop();
      },
      onPanStart: (detail) {
        Navigator.of(context).pop();
      },
      child: _buildBarrierShape(),
    );
  }

  Widget _buildBarrierShape() {
    final Color bgColor = barrierColor ?? Colors.transparent;
    switch (barrierShape) {
      case BarrierShape.headerTrans:
        return CustomPaint(
          painter: HeaderTransPainter(position.top, bgColor),
          child: const SizedBox.expand(),
        );
      default: //normal
        return ColoredBox(
          color: bgColor,
          child: const SizedBox.expand(),
        );
    }
  }
}

/// Modal Barrier - Painter
class HeaderTransPainter extends CustomPainter {
  double topPosition;
  Color color;

  HeaderTransPainter(this.topPosition, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    Paint bgPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    canvas.drawRect(
        Rect.fromLTWH(0.0, topPosition, size.width, size.height), bgPaint);
  }

  @override
  bool shouldRepaint(HeaderTransPainter oldDelegate) {
    return true;
  }
}
