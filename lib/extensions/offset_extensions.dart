import 'package:flutter/rendering.dart';

extension OffsetInsideBoundingBox on Offset {
  bool isInside(Rect rect) {
    if (dx > rect.left &&
        dx < rect.right &&
        dy > rect.top &&
        dy < rect.bottom) {
      return true;
    }
    return false;
  }
}
