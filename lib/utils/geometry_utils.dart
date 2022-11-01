import 'dart:math';

import 'package:flutter/material.dart';

bool isInObject(Point<double> point, double radius, double dx, double dy) {
  Path tempPath = Path()
    ..addOval(
        Rect.fromCircle(center: Offset(point.x, point.y), radius: radius));
  return tempPath.contains(Offset(dx, dy));
}
