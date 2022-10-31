import 'package:flutter/material.dart';

class SelectionPainter extends CustomPainter {
  final colors = [Colors.red, Colors.yellow, Colors.lightBlue];
  Path path = Path();
  Paint _paint = Paint()
    ..color = Colors.red
    ..strokeWidth = 5
    ..strokeCap = StrokeCap.round;

  final bool down;
  final double x;
  final double y;
  Map<int, Map<String, double>> pathList;

  SelectionPainter({
    required this.down,
    required this.x,
    required this.y,
    required this.pathList,
  });
  @override
  void paint(Canvas canvas, Size size) {
    for (var pathData in pathList.values) {
      path = Path()
        ..addOval(Rect.fromCircle(
            center: Offset(pathData['x']!, pathData['y']!),
            radius: pathData['r']!));
      canvas.drawPath(path, _paint);
    }
  }

  @override
  bool shouldRepaint(SelectionPainter oldDelegate) => down;
}
