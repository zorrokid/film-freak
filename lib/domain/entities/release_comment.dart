import 'entity.dart';

class ReleaseComment extends ReleaseChildEntity<ReleaseComment> {
  final String comment;
  ReleaseComment({
    int? id,
    required int releaseId,
    required this.comment,
    DateTime? createdTime,
    DateTime? modifiedTime,
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
        'comment': comment,
        'createdTime': (createdTime ?? DateTime.now()).toIso8601String(),
        'modifiedTime': (modifiedTime ?? DateTime.now()).toIso8601String(),
      };

  static ReleaseComment fromMap(Map<String, dynamic> map) {
    return ReleaseComment(
      id: map['id'] as int,
      releaseId: map['releaseId'] as int,
      comment: map['comment'] as String,
      createdTime: DateTime.parse(map['createdTime'] as String),
      modifiedTime: DateTime.parse(map['modifiedTime'] as String),
    );
  }
}
