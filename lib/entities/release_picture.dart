import 'package:film_freak/enums/picture_type.dart';

import 'entity.dart';

class ReleasePicture extends ChildEntity<ReleasePicture> {
  // when creating a new release id is set after entity is saved to db:
  String filename;
  PictureType pictureType;

  ReleasePicture.full(
    int? releaseId,
    int? id,
    DateTime? createdTime,
    DateTime? modifiedTime, {
    required this.filename,
    required this.pictureType,
  }) : super.full(
          id,
          createdTime,
          modifiedTime,
        );

  ReleasePicture(
    int? id, {
    required this.filename,
    required this.pictureType,
  }) : super(id);

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
    return ReleasePicture.full(
      map['releaseId'] as int,
      map['id'] as int,
      map['createdTime'] as DateTime,
      map['modifiedTime'] as DateTime,
      filename: map['filename'],
      pictureType: PictureType.values[map['pictureType'] as int],
    );
  }
}
