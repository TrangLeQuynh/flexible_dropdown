import 'package:flutter/material.dart';

class ModalBarrierLayout extends StatelessWidget {
  final RelativeRect position;
  const ModalBarrierLayout({
    Key? key,
    required this.position,
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
      child: ColoredBox(
        color: Colors.black38.withOpacity(.15),
        child: const SizedBox.expand(),
      ),
    );
  }
}
