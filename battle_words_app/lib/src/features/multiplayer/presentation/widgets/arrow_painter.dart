import 'package:flutter/material.dart';

class ArrowPainter extends CustomPainter {
  final int col;
  final int row;

  ArrowPainter({required this.col, required this.row});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    final rect = Rect.fromLTWH(
      col * size.width / 6,
      row * size.height / 6,
      size.width / 6,
      size.height / 6,
    );

    canvas.drawOval(rect, paint);
  }

  @override
  bool shouldRepaint(ArrowPainter oldDelegate) => col != oldDelegate.col || row != oldDelegate.row;
}
