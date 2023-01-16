import 'entity.dart';

class CollectionItemComment
    extends CollectionItemChildEntity<CollectionItemComment> {
  String comment;

  CollectionItemComment({
    int? collectionItemId,
    int? id,
    DateTime? createdTime,
    DateTime? modifiedTime,
    required this.comment,
  }) : super(
          id: id,
          collectionItemId: collectionItemId,
          createdTime: createdTime,
          modifiedTime: modifiedTime,
        );

  @override
  Map<String, dynamic> get map => {
        'id': id,
        'collectionItemId': collectionItemId,
        'comment': comment,
        'createdTime': (createdTime ?? DateTime.now()).toIso8601String(),
        'modifiedTime': (modifiedTime ?? DateTime.now()).toIso8601String(),
      };

  static CollectionItemComment fromMap(Map<String, Object?> map) {
    return CollectionItemComment(
      collectionItemId: map['collectionItemId'] as int,
      id: map['id'] as int,
      createdTime: DateTime.parse(map['createdTime'] as String),
      modifiedTime: DateTime.parse(map['modifiedTime'] as String),
      comment: map['comment'] as String,
    );
  }
}
