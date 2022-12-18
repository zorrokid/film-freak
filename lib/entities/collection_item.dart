import '../enums/collection_status.dart';
import '../enums/condition.dart';
import 'entity.dart';

class CollectionItem extends ReleaseChildEntity<CollectionItem> {
  Condition condition;
  CollectionStatus status;

  CollectionItem({
    int? id,
    DateTime? createdTime,
    DateTime? modifiedTime,
    required int releaseId,
    required this.condition,
    required this.status,
  }) : super(
          id: id,
          releaseId: releaseId,
          createdTime: createdTime,
          modifiedTime: modifiedTime,
        );

  CollectionItem.empty(int releaseId)
      : this(
          releaseId: releaseId,
          condition: Condition.unknown,
          status: CollectionStatus.unknown,
        );

  @override
  Map<String, dynamic> get map => {
        'id': id,
        'releaseId': releaseId,
        'condition': condition.index,
        'status': status.index,
        'createdTime': (createdTime ?? DateTime.now()).toIso8601String(),
        'modifiedTime': (modifiedTime ?? DateTime.now()).toIso8601String(),
      };

  static CollectionItem fromMap(Map<String, Object?> map) {
    return CollectionItem(
      id: map['id'] as int,
      releaseId: map['releaseId'] as int,
      createdTime: DateTime.parse(map['createdTime'] as String),
      modifiedTime: DateTime.parse(map['modifiedTime'] as String),
      condition: Condition.values[map['condition'] as int],
      status: CollectionStatus.values[map['status'] as int],
    );
  }
}
