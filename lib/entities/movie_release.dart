import 'entity.dart';
import '../enums/case_type.dart';
import '../enums/media_type.dart';

class MovieRelease extends Entity<MovieRelease> {
  String name;
  MediaType mediaType;
  String barcode;
  CaseType caseType;
  String notes;
  int? movieId;

  MovieRelease({
    int? id,
    DateTime? createdTime,
    DateTime? modifiedTime,
    required this.name,
    required this.mediaType,
    required this.barcode,
    required this.caseType,
    required this.notes,
    this.movieId,
  }) : super(
          id: id,
          createdTime: createdTime,
          modifiedTime: modifiedTime,
        );

  MovieRelease.empty()
      : this(
          name: '',
          barcode: '',
          caseType: CaseType.unknown,
          mediaType: MediaType.unknown,
          notes: '',
        );

  @override
  Map<String, dynamic> get map => {
        'name': name,
        'mediaType': mediaType.index,
        'barcode': barcode,
        'caseType': caseType.index,
        'notes': notes,
        'createdTime': (createdTime ?? DateTime.now()).toIso8601String(),
        'modifiedTime': (modifiedTime ?? DateTime.now()).toIso8601String(),
        'movieId': movieId,
      };

  static MovieRelease fromMap(Map<String, Object?> map) {
    return MovieRelease(
      id: map['id'] as int,
      createdTime: DateTime.parse(map['createdTime'] as String),
      modifiedTime: DateTime.parse(map['modifiedTime'] as String),
      name: map['name'] as String,
      mediaType: MediaType.values[map['mediaType'] as int],
      barcode: map['barcode'] as String,
      caseType: CaseType.values[map['caseType'] as int],
      notes: map['notes'] as String,
      movieId: map['movieId'] as int,
    );
  }

  /* JSON example:
    {
      "name": "",
      "mediaType": "",
      "barcode": "",
      "caseType": "",
      "condition": "",
      "notes": "",
      "createdTime": "",
      "modifiedTime": "",
      "hasSlipCover": ""
    }
  */
  static MovieRelease fromJson(Map<String, Object?> json) {
    return MovieRelease(
      name: json['name'] as String,
      mediaType: MediaType.values[json['mediaType'] as int],
      barcode: json['barcode'] as String,
      caseType: CaseType.values[json['caseType'] as int],
      notes: json['notes'] as String,
    );
  }
}
