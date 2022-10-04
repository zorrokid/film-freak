import 'package:film_freak/models/enums.dart';

class MovieRelease {
  final int id;
  final String name;
  final MediaType mediaType;
  final String barcode;
  final CaseType caseType;

  const MovieRelease(
      {required this.id,
      required this.name,
      required this.mediaType,
      required this.barcode,
      required this.caseType});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'mediaType': mediaType.index,
      'barcode': barcode,
      'caseType': caseType.index
    };
  }

  static MovieRelease fromMap(Map<String, Object?> map) {
    return MovieRelease(
        id: map['id'] as int,
        name: map['name'] as String,
        mediaType: MediaType.values[map['mediaType'] as int],
        barcode: map['barcode'] as String,
        caseType: CaseType.values[map['caseType'] as int]);
  }
}
