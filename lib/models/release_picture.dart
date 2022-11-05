import 'package:film_freak/models/picture_type.dart';

class ReleasePicture {
  // when creating a new entity id is set after entity is saved to db:
  int? id;
  // when creating a new release id is set after entity is saved to db:
  int? releaseId;
  String filename;
  PictureType pictureType;
  DateTime? createdTime;
  DateTime? modifiedTime;
  ReleasePicture(
      {this.id,
      this.releaseId,
      required this.filename,
      required this.pictureType,
      this.createdTime,
      this.modifiedTime});

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
        id: map['id'] as int,
        releaseId: map['releaseId'] as int,
        filename: map['filename'],
        pictureType: PictureType.values[map['pictureType'] as int]);
  }
}
