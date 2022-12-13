import 'package:film_freak/enums/condition.dart';

import '../enums/media_type.dart';
import 'entity.dart';

class ReleaseMedia extends ReleaseChildEntity<ReleaseMedia> {
  // when creating a new release id is set after entity is saved to db:
  MediaType mediaType;
  Condition condition;
  ReleaseMedia({
    int? releaseId,
    int? id,
    DateTime? createdTime,
    DateTime? modifiedTime,
    required this.mediaType,
    Condition? condition,
  }) : super(
          id: id,
          releaseId: releaseId,
          createdTime: createdTime,
          modifiedTime: modifiedTime,
        );

  @override
  Map<String, dynamic> get map => {
        'id': id,
        'releaseId': releaseId,
        'mediaType': mediaType.index,
        'condition': condition.index,
        'createdTime': (createdTime ?? DateTime.now()).toIso8601String(),
        'modifiedTime': (modifiedTime ?? DateTime.now()).toIso8601String(),
      };

  static ReleaseMedia fromMap(Map<String, dynamic> map) {
    return ReleaseMedia(
      releaseId: map['releaseId'] as int,
      id: map['id'] as int,
      mediaType: MediaType.values[map['mediaType'] as int],
      condition: Condition.values[map['condition'] as int],
      createdTime: DateTime.parse(map['createdTime'] as String),
      modifiedTime: DateTime.parse(map['modifiedTime'] as String),
    );
  }
}
