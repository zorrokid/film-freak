import 'package:film_freak/models/enums.dart';

class MovieRelease {
  final int id;
  final String name;
  final MediaType mediaType;
  final String barcode;

  const MovieRelease(
      {required this.id,
      required this.name,
      required this.mediaType,
      required this.barcode});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'mediaType': mediaType, 'barcode': barcode};
  }
}
