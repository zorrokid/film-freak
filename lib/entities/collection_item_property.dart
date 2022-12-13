import 'package:film_freak/entities/entity.dart';

import '../enums/collection_item_property_type.dart';

class CollectionItemProperty
    extends CollectionItemChildEntity<CollectionItemProperty> {
  CollectionItemPropertyType propertyType;

  CollectionItemProperty({
    int? collectionItemId,
    int? id,
    DateTime? createdTime,
    DateTime? modifiedTime,
    required this.propertyType,
  }) : super(
          id: id,
          createdTime: createdTime,
          modifiedTime: modifiedTime,
        );

  @override
  Map<String, dynamic> get map => {
        'id': id,
        'collectionItemId': collectionItemId,
        'propertyType': propertyType.index,
        'createdTime': (createdTime ?? DateTime.now()).toIso8601String(),
        'modifiedTime': (modifiedTime ?? DateTime.now()).toIso8601String(),
      };

  static CollectionItemProperty fromMap(Map<String, Object?> map) {
    return CollectionItemProperty(
      collectionItemId: map['collectionItemId'] as int,
      id: map['id'] as int,
      createdTime: DateTime.parse(map['createdTime'] as String),
      modifiedTime: DateTime.parse(map['modifiedTime'] as String),
      propertyType:
          CollectionItemPropertyType.values[map['propertyType'] as int],
    );
  }
}
