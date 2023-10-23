import 'package:flutter/material.dart';
import '../models/enum_type.dart';

/// [ModalBarrierLayout] use to customize [ModalBarrier]
///
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
    Key? key,
    required this.position,
    this.barrierColor,
    this.barrierShape,
  }) : super(key: key);

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
      child: _buildLayoutShape(),
    );
  }

  Widget _buildLayoutShape() {
    final Color bgColor = barrierColor ?? Colors.black38.withOpacity(.2);
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
    return topPosition != oldDelegate.topPosition;
  }
}
