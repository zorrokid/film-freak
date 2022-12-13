import 'entity.dart';
import '../enums/case_type.dart';
import '../enums/media_type.dart';

class Release extends Entity<Release> {
  String name;
  String barcode;
  CaseType caseType;
  String notes;
  int? movieId;

  Release({
    int? id,
    DateTime? createdTime,
    DateTime? modifiedTime,
    required this.name,
    required this.barcode,
    required this.caseType,
    required this.notes,
    this.movieId,
  }) : super(
          id: id,
          createdTime: createdTime,
          modifiedTime: modifiedTime,
        );

  Release.empty()
      : this(
          name: '',
          barcode: '',
          caseType: CaseType.unknown,
          notes: '',
        );

  @override
  Map<String, dynamic> get map => {
        'name': name,
        'barcode': barcode,
        'caseType': caseType.index,
        'notes': notes,
        'createdTime': (createdTime ?? DateTime.now()).toIso8601String(),
        'modifiedTime': (modifiedTime ?? DateTime.now()).toIso8601String(),
        'movieId': movieId,
      };

  static Release fromMap(Map<String, Object?> map) {
    return Release(
      id: map['id'] as int,
      createdTime: DateTime.parse(map['createdTime'] as String),
      modifiedTime: DateTime.parse(map['modifiedTime'] as String),
      name: map['name'] as String,
      barcode: map['barcode'] as String,
      caseType: CaseType.values[map['caseType'] as int],
      notes: map['notes'] as String,
      movieId: map['movieId'] as int?,
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
  static Release fromJson(Map<String, Object?> json) {
    return Release(
      name: json['name'] as String,
      barcode: json['barcode'] as String,
      caseType: CaseType.values[json['caseType'] as int],
      notes: json['notes'] as String,
    );
  }
}
