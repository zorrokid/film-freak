import 'package:sqflite/sqflite.dart';

import '../../entities/entity.dart';
import '../db_provider.dart';

class RepositoryBase<T extends ChildEntity> {
  final DatabaseProvider databaseProvider;
  final String tableName;
  RepositoryBase(this.databaseProvider, this.tableName);

  Future<Iterable<T>> getBy(
      int releaseId, String column, Function mapper) async {
    Database db = await databaseProvider.database;
    List<Map<String, Object?>> queryResult = await db
        .rawQuery('SELECT * FROM $tableName WHERE $column = $releaseId');
    var result = queryResult.map<T>((e) => mapper(e));
    return result;
  }

  Future<int> delete(int id) async {
    Database db = await databaseProvider.database;
    return await db.delete(tableName, where: 'id = $id');
  }

  Future<int> deleteByIdColumn(int id, String columnName) async {
    Database db = await databaseProvider.database;
    return await db.delete(tableName, where: '$columnName = $id');
  }
}
