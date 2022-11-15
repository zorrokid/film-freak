import '../enums/release_property_type.dart';

class ReleaseProperty {
  int? id;
  int releaseId;
  ReleasePropertyType propertyType;
  DateTime? createdTime;
  DateTime? modifiedTime;

  ReleaseProperty(
      {this.id,
      required this.releaseId,
      required this.propertyType,
      this.createdTime,
      this.modifiedTime});

  Map<String, dynamic> get map => {
        'id': id,
        'relaseId': releaseId,
        'propertyType': propertyType,
        'createdTime': (createdTime ?? DateTime.now()).toIso8601String(),
        'modifiedTime': (modifiedTime ?? DateTime.now()).toIso8601String(),
      };

  static ReleaseProperty fromMap(Map<String, Object?> map) {
    return ReleaseProperty(
      id: map['id'] as int,
      releaseId: map['releaseId'] as int,
      propertyType: ReleasePropertyType.values[map['propertyType'] as int],
      createdTime: DateTime.parse(map['createdTime'] as String),
      modifiedTime: DateTime.parse(map['modifiedTime'] as String),
    );
  }
}
