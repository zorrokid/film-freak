import 'package:film_freak/enums/case_type.dart';

import '../enums/condition.dart';
import '../enums/media_type.dart';
import 'entity.dart';

class MovieRelease extends Entity<MovieRelease> {
  // when creating a new release id is set after entity is saved to db:
  int? id;
  String name;
  MediaType mediaType;
  String barcode;
  CaseType caseType;
  Condition condition;
  String notes;
  DateTime? createdTime;
  DateTime? modifiedTime;
  bool hasSlipCover;

  MovieRelease(
      {this.id,
      required this.name,
      required this.mediaType,
      required this.barcode,
      required this.caseType,
      required this.condition,
      required this.hasSlipCover,
      required this.notes,
      this.createdTime,
      this.modifiedTime});

  MovieRelease.init()
      : this(
            name: '',
            barcode: '',
            caseType: CaseType.unknown,
            condition: Condition.unknown,
            hasSlipCover: false,
            mediaType: MediaType.unknown,
            notes: '');

  Map<String, dynamic> get map => {
        'name': name,
        'mediaType': mediaType.index,
        'barcode': barcode,
        'caseType': caseType.index,
        'condition': condition.index,
        'notes': notes,
        'hasSlipCover': hasSlipCover ? 1 : 0,
        'createdTime': (createdTime ?? DateTime.now()).toIso8601String(),
        'modifiedTime': (modifiedTime ?? DateTime.now()).toIso8601String(),
      };

  static MovieRelease fromMap(Map<String, Object?> map) {
    return MovieRelease(
        id: map['id'] as int,
        name: map['name'] as String,
        mediaType: MediaType.values[map['mediaType'] as int],
        barcode: map['barcode'] as String,
        caseType: CaseType.values[map['caseType'] as int],
        condition: Condition.values[map['condition'] as int],
        notes: map['notes'] as String,
        createdTime: DateTime.parse(map['createdTime'] as String),
        modifiedTime: DateTime.parse(map['modifiedTime'] as String),
        hasSlipCover: (map['hasSlipCover'] as int) == 1 ? true : false);
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
        condition: Condition.values[json['condition'] as int],
        notes: json['notes'] as String,
        hasSlipCover: (json['hasSlipCover'] as int) == 1 ? true : false);
  }
}
