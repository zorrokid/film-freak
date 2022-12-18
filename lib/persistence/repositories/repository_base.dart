import 'package:sqflite/sqflite.dart';

import '../../entities/entity.dart';
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
    Database db = await databaseProvider.database;
    final query =
        await db.query(tableName, where: '$column=?', whereArgs: [id]);
    final result = query.map<T>((e) => mapper(e));
    return result;
  }

  Future<T> get(int id) async {
    Database db = await databaseProvider.database;
    final query = await db.query(tableName, where: 'id=?', whereArgs: [id]);
    final result = query.map<T>((e) => mapper(e));
    return result.single;
  }

  Future<int> delete(int id) async {
    Database db = await databaseProvider.database;
    return await db.delete(tableName, where: 'id = $id');
  }

  Future<int> deleteByIdColumn(int id, String columnName) async {
    Database db = await databaseProvider.database;
    return await db.delete(tableName, where: '$columnName = $id');
  }

  Future<int> insert(T entity) async {
    Database db = await databaseProvider.database;
    return await db.insert(tableName, entity.map);
  }

  Future<int> update(T entity) async {
    Database db = await databaseProvider.database;
    return await db
        .update(tableName, entity.map, where: 'id=?', whereArgs: [entity.id]);
  }

  Future<int> upsert(T entity) async {
    Database db = await databaseProvider.database;
    int? id = entity.id;
    if (id != null) {
      await db.update(tableName, entity.map, where: 'id=?', whereArgs: [id]);
      return id;
    }
    return await db.insert(tableName, entity.map);
  }

  Future<Iterable<T>> getByIds(Iterable<int> ids) async {
    Database db = await databaseProvider.database;
    String idsArg = ids.join(',');
    final query = await db.query(tableName, where: 'id IN ($idsArg)');
    final result = query.map<T>((e) => mapper(e));
    return result;
  }
}
