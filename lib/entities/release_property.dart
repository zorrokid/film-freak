import 'package:film_freak/entities/entity.dart';

import '../enums/release_property_type.dart';

class ReleaseProperty extends ChildEntity<ReleaseProperty> {
  // when creating a new entity id is set after entity is saved to db:
  int? id;
  ReleasePropertyType propertyType;
  DateTime? createdTime;
  DateTime? modifiedTime;

  ReleaseProperty(int? releaseId,
      {this.id,
      required this.propertyType,
      this.createdTime,
      this.modifiedTime})
      : super(releaseId: releaseId);

  Map<String, dynamic> get map => {
        'id': id,
        'releaseId': releaseId,
        'propertyType': propertyType.index,
        'createdTime': (createdTime ?? DateTime.now()).toIso8601String(),
        'modifiedTime': (modifiedTime ?? DateTime.now()).toIso8601String(),
      };
}
