import 'package:film_freak/enums/picture_type.dart';

import 'entity.dart';

class ReleasePicture extends ChildEntity<ReleasePicture> {
  // when creating a new release id is set after entity is saved to db:
  String filename;
  PictureType pictureType;

  ReleasePicture({
    int? releaseId,
    int? id,
    DateTime? createdTime,
    DateTime? modifiedTime,
    required this.filename,
    required this.pictureType,
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
        'filename': filename,
        'pictureType': pictureType.index,
        'createdTime': (createdTime ?? DateTime.now()).toIso8601String(),
        'modifiedTime': (modifiedTime ?? DateTime.now()).toIso8601String(),
      };

  static ReleasePicture fromMap(Map<String, dynamic> map) {
    return ReleasePicture(
      releaseId: map['releaseId'] as int,
      id: map['id'] as int,
      createdTime: DateTime.parse(map['createdTime'] as String),
      modifiedTime: DateTime.parse(map['modifiedTime'] as String),
      filename: map['filename'],
      pictureType: PictureType.values[map['pictureType'] as int],
    );
  }
}
