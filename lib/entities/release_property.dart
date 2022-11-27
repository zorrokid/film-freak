import 'package:film_freak/entities/entity.dart';

import '../enums/release_property_type.dart';

class ReleaseProperty extends ChildEntity<ReleaseProperty> {
  ReleasePropertyType propertyType;

  ReleaseProperty.full({
    int? releaseId,
    int? id,
    DateTime? createdTime,
    DateTime? modifiedTime,
    required this.propertyType,
  }) : super.full(
          id: id,
          createdTime: createdTime,
          modifiedTime: modifiedTime,
        );

  ReleaseProperty({
    int? id,
    int? releaseId,
    required this.propertyType,
  }) : super(
          id: id,
          releaseId: releaseId,
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
    return ReleaseProperty.full(
      releaseId: map['releaseId'] as int,
      id: map['id'] as int,
      createdTime: DateTime.parse(map['createdTime'] as String),
      modifiedTime: DateTime.parse(map['modifiedTime'] as String),
      propertyType: ReleasePropertyType.values[map['propertyType'] as int],
    );
  }
}
