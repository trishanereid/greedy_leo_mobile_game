import 'package:flutter/material.dart';

class SemiFilledCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 5;

    final strokePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(center, radius, strokePaint);

    final whiteCirclePaint = Paint()
      ..color = Colors.white;
    canvas.drawCircle(center, radius, whiteCirclePaint);

    final yellowPaint = Paint()..color = Colors.yellow.shade300;
    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(rect, 0, 3.14159, true, yellowPaint);

    final blackLinePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.7;
    canvas.drawLine(
      Offset(center.dx - radius, center.dy),
      Offset(center.dx + radius, center.dy),
      blackLinePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}