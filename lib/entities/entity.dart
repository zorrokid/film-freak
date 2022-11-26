abstract class Entity<T> {
  // set after saved to db
  int? id;
  DateTime? createdTime;
  DateTime? modifiedTime;
  Entity({
    this.id,
    this.createdTime,
    this.modifiedTime,
  });

  Map<String, dynamic> get map;
}

abstract class ChildEntity<T> extends Entity<T> {
  int? releaseId;

  ChildEntity.full(
    int? id,
    DateTime? createdTime,
    DateTime? modifiedTime, {
    this.releaseId,
  }) : super(
          id: id,
          createdTime: createdTime,
          modifiedTime: modifiedTime,
        );

  ChildEntity(
    int? id, {
    this.releaseId,
  }) : super(id: id);
}
