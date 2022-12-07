import '../enums/condition.dart';
import 'entity.dart';

class CollectionItem extends Entity<CollectionItem> {
  int releaseId;
  Condition condition;
  String notes;
  bool hasSlipCover;

  CollectionItem({
    int? id,
    DateTime? createdTime,
    DateTime? modifiedTime,
    required this.releaseId,
    required this.condition,
    required this.hasSlipCover,
    required this.notes,
  }) : super(
          id: id,
          createdTime: createdTime,
          modifiedTime: modifiedTime,
        );

  CollectionItem.empty(int releaseId)
      : this(
          releaseId: releaseId,
          condition: Condition.unknown,
          hasSlipCover: false,
          notes: '',
        );

  @override
  Map<String, dynamic> get map => {
        'id': id,
        'releaseId': releaseId,
        'condition': condition.index,
        'notes': notes,
        'hasSlipCover': hasSlipCover ? 1 : 0,
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
      notes: map['notes'] as String,
      hasSlipCover: (map['hasSlipCover'] as int) == 1 ? true : false,
    );
  }
}
