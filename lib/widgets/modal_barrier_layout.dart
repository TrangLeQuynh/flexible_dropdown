import 'package:flutter/material.dart';
import '../models/enum_type.dart';

class ModalBarrierLayout extends StatelessWidget {
  final RelativeRect position;
  final Color? barrierColor;
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
    switch(barrierShape) {
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

class HeaderTransPainter extends CustomPainter {
  double topPosition;
  Color color;

  HeaderTransPainter(this.topPosition, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    Paint bgPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    canvas.drawRect(Rect.fromLTWH(0.0, topPosition, size.width, size.height), bgPaint);
  }

  @override
  bool shouldRepaint(HeaderTransPainter oldDelegate) {
    return oldDelegate.topPosition != topPosition;
  }
}
