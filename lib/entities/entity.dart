abstract class Entity<T> {}

abstract class ChildEntity<T> {
  int? releaseId;
  ChildEntity({this.releaseId});
}
