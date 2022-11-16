import 'package:sqflite/sqflite.dart';

import '../../entities/entity.dart';
import '../db_provider.dart';

class RepositoryBase<T extends Entity> {
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
}
