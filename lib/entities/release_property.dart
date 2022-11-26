import 'package:film_freak/entities/entity.dart';

import '../enums/release_property_type.dart';

class ReleaseProperty extends ChildEntity<ReleaseProperty> {
  ReleasePropertyType propertyType;

  ReleaseProperty.full(
    int? releaseId,
    int? id,
    DateTime? createdTime,
    DateTime? modifiedTime, {
    required this.propertyType,
  }) : super.full(
          id,
          createdTime,
          modifiedTime,
        );

  ReleaseProperty(
    int? id, {
    required this.propertyType,
  }) : super(id);

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
      map['releaseId'] as int,
      map['id'] as int,
      map['createdTime'] as DateTime,
      map['modifiedTime'] as DateTime,
      propertyType: ReleasePropertyType.values[map['propertyType'] as int],
    );
  }
}
