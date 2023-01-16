import 'entity.dart';
import '../enums/condition.dart';

class CollectionItemMedia
    extends CollectionItemChildEntity<CollectionItemMedia> {
  final int releaseMediaId;
  final Condition condition;
  CollectionItemMedia({
    int? id,
    int? collectionItemId,
    required this.releaseMediaId,
    required this.condition,
    DateTime? createdTime,
    DateTime? modifiedTime,
  }) : super(
            id: id,
            createdTime: createdTime,
            modifiedTime: modifiedTime,
            collectionItemId: collectionItemId);

  @override
  Map<String, dynamic> get map => {
        'id': id,
        'releaseMediaId': releaseMediaId,
        'collectionItemId': releaseMediaId,
        'condition': condition.index,
        'createdTime': (createdTime ?? DateTime.now()).toIso8601String(),
        'modifiedTime': (modifiedTime ?? DateTime.now()).toIso8601String(),
      };

  static CollectionItemMedia fromMap(Map<String, Object?> map) {
    return CollectionItemMedia(
      id: map['id'] as int,
      releaseMediaId: map['releaseMediaId'] as int,
      collectionItemId: map['collectionItemId'] as int,
      createdTime: DateTime.parse(map['createdTime'] as String),
      modifiedTime: DateTime.parse(map['modifiedTime'] as String),
      condition: Condition.values[map['condition'] as int],
    );
  }
}
