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

abstract class ReleaseChildEntity<T> extends Entity<T> {
  int? releaseId;

  ReleaseChildEntity({
    int? id,
    DateTime? createdTime,
    DateTime? modifiedTime,
    this.releaseId,
  }) : super(
          id: id,
          createdTime: createdTime,
          modifiedTime: modifiedTime,
        );
}

abstract class CollectionItemChildEntity<T> extends Entity<T> {
  int? collectionItemId;

  CollectionItemChildEntity({
    int? id,
    DateTime? createdTime,
    DateTime? modifiedTime,
    this.collectionItemId,
  }) : super(
          id: id,
          createdTime: createdTime,
          modifiedTime: modifiedTime,
        );
}
