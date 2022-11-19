import 'package:film_freak/enums/picture_type.dart';

import 'entity.dart';

class ReleasePicture extends ChildEntity<ReleasePicture> {
  // when creating a new entity id is set after entity is saved to db:
  int? id;
  // when creating a new release id is set after entity is saved to db:
  String filename;
  PictureType pictureType;
  DateTime? createdTime;
  DateTime? modifiedTime;
  ReleasePicture(int? releaseId,
      {this.id,
      required this.filename,
      required this.pictureType,
      this.createdTime,
      this.modifiedTime})
      : super(releaseId: releaseId);

  Map<String, dynamic> get map => {
        'id': id,
        'releaseId': releaseId,
        'filename': filename,
        'pictureType': pictureType.index,
        'createdTime': (createdTime ?? DateTime.now()).toIso8601String(),
        'modifiedTime': (modifiedTime ?? DateTime.now()).toIso8601String(),
      };

  static ReleasePicture fromMap(Map<String, dynamic> map) {
    return ReleasePicture(map['releaseId'] as int,
        id: map['id'] as int,
        filename: map['filename'],
        pictureType: PictureType.values[map['pictureType'] as int]);
  }
}
