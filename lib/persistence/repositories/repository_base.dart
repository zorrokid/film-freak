import '../../domain/entities/entity.dart';
import '../db_provider.dart';

abstract class RepositoryBase<T extends Entity> {
  final DatabaseProvider databaseProvider;
  final String tableName;
  final Function mapper;

  RepositoryBase(
    this.databaseProvider,
    this.tableName,
    this.mapper,
  );

  Future<Iterable<T>> getById(int id, String column) async {
    final db = await databaseProvider.database;
    final query =
        await db.query(tableName, where: '$column=?', whereArgs: [id]);
    return query.map<T>((e) => mapper(e));
  }

  Future<T> get(int id) async {
    final db = await databaseProvider.database;
    final query = await db.query(tableName, where: 'id=?', whereArgs: [id]);
    return query.map<T>((e) => mapper(e)).single;
  }

  Future<int> delete(int id) async {
    final db = await databaseProvider.database;
    return await db.delete(tableName, where: 'id = $id');
  }

  Future<int> deleteByIdColumn(int id, String columnName) async {
    final db = await databaseProvider.database;
    return await db.delete(tableName, where: '$columnName = $id');
  }

  Future<int> insert(T entity) async {
    final db = await databaseProvider.database;
    return await db.insert(tableName, entity.map);
  }

  Future<int> update(T entity) async {
    final db = await databaseProvider.database;
    return await db
        .update(tableName, entity.map, where: 'id=?', whereArgs: [entity.id]);
  }

  Future<int> upsert(T entity) async {
    final db = await databaseProvider.database;
    final int? id = entity.id;
    if (id != null) {
      await db.update(tableName, entity.map, where: 'id=?', whereArgs: [id]);
      return id;
    }
    return await db.insert(tableName, entity.map);
  }

  Future<Iterable<T>> getByIds(Iterable<int> ids) async {
    final db = await databaseProvider.database;
    final idsArg = ids.join(',');
    final query = await db.query(tableName, where: 'id IN ($idsArg)');
    return query.map<T>((e) => mapper(e));
  }
}
