import 'package:film_freak/models/case_type.dart';

import 'condition.dart';
import 'media_type.dart';

class MovieRelease {
  final int? id;
  final String name;
  final MediaType mediaType;
  final String barcode;
  final CaseType caseType;
  final Condition condition;
  final String? notes;
  final DateTime? createdTime;

  const MovieRelease(
      {this.id,
      required this.name,
      required this.mediaType,
      required this.barcode,
      required this.caseType,
      required this.condition,
      this.notes,
      this.createdTime});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'mediaType': mediaType.index,
      'barcode': barcode,
      'caseType': caseType.index,
      'condition': condition.index,
      'notes': notes ?? ''
    };
  }

  static MovieRelease fromMap(Map<String, Object?> map) {
    return MovieRelease(
        id: map['id'] as int,
        name: map['name'] as String,
        mediaType: MediaType.values[map['mediaType'] as int],
        barcode: map['barcode'] as String,
        caseType: CaseType.values[map['caseType'] as int],
        condition: Condition.values[map['condition'] as int],
        notes: map['notes'] as String,
        createdTime: map['createdTime'] as DateTime?);
  }
}
