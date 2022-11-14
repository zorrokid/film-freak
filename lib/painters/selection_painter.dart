import 'dart:math';

import 'package:flutter/material.dart';

const double selectionHandleSize = 150;

class SelectionPainter extends CustomPainter {
  final Paint _paint = Paint()
    ..color = Colors.red
    ..strokeWidth = 10
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke;

  final bool down;
  final double x;
  final double y;
  List<Point<double>> selectionPoints;

  SelectionPainter({
    required this.down,
    required this.x,
    required this.y,
    required this.selectionPoints,
  });
  @override
  void paint(Canvas canvas, Size size) {
    for (var point in selectionPoints) {
      final path = Path()
        ..addOval(Rect.fromCircle(
            center: Offset(point.x, point.y), radius: selectionHandleSize))
        ..addPolygon(
            selectionPoints.map((e) => Offset(e.x, e.y)).toList(), true);
      canvas.drawPath(path, _paint);
    }
  }

  @override
  bool shouldRepaint(SelectionPainter oldDelegate) => down;
}
