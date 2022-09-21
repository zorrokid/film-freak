import 'package:flutter/foundation.dart';

enum MediaType { vhs, dvd, bluRay }

extension MediaTypeExtension on MediaType {
  String toUiString() {
    return describeEnum(this).toUpperCase();
  }
}

const mediaTypeValues = [MediaType.bluRay, MediaType.dvd, MediaType.vhs];
