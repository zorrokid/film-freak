import 'package:flutter/foundation.dart';

import 'enum_form_field.dart';

enum MediaType { vhs, dvd, bluRay }

extension MediaTypeExtension on MediaType {
  String toUiString() {
    return describeEnum(this).toUpperCase();
  }
}

const mediaTypeValues = [MediaType.bluRay, MediaType.dvd, MediaType.vhs];

final Iterable<MediaTypeFormField> mediaTypeFormFieldValues =
    mediaTypeValues.map((e) => MediaTypeFormField(mediaType: e));

class MediaTypeFormField extends EnumFormField<MediaType> {
  final MediaType mediaType;
  MediaTypeFormField({required this.mediaType});
  @override
  String toUiString() {
    return mediaType.toUiString();
  }

  @override
  get value => mediaType;
}
