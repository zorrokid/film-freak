import 'package:film_freak/entities/entity.dart';

import '../enums/release_property_type.dart';

class ReleaseProperty extends Entity<ReleaseProperty> {
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
}
