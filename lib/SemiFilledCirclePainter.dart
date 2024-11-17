import 'package:flutter/material.dart';

class SemiFilledCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 5;

    // Draw the white background circle
    final whiteCirclePaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, radius, whiteCirclePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}