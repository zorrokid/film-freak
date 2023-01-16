import 'entity.dart';
import '../enums/release_property_type.dart';

class ReleaseProperty extends ReleaseChildEntity<ReleaseProperty> {
  ReleasePropertyType propertyType;

  ReleaseProperty({
    int? releaseId,
    int? id,
    DateTime? createdTime,
    DateTime? modifiedTime,
    required this.propertyType,
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
        'propertyType': propertyType.index,
        'createdTime': (createdTime ?? DateTime.now()).toIso8601String(),
        'modifiedTime': (modifiedTime ?? DateTime.now()).toIso8601String(),
      };

  static ReleaseProperty fromMap(Map<String, Object?> map) {
    return ReleaseProperty(
      releaseId: map['releaseId'] as int,
      id: map['id'] as int,
      createdTime: DateTime.parse(map['createdTime'] as String),
      modifiedTime: DateTime.parse(map['modifiedTime'] as String),
      propertyType: ReleasePropertyType.values[map['propertyType'] as int],
    );
  }
}
