import 'package:flutter/material.dart';

class SemiFilledCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 5;

    final gradient = RadialGradient(
      colors: [
        Color(0xFF777777),
        Color(0xFF696969),
      ],
      stops: [0.5, 0.8],
    );

    final whiteCirclePaint = Paint()
      ..shader = gradient.createShader(Rect.fromCircle(
          center: center,
          radius: radius)
      );

    canvas.drawCircle(center, radius, whiteCirclePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}