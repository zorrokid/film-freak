import 'package:sqflite/sqflite.dart';

import '../db_provider.dart';

class SystemInfoRepository {
  final DatabaseProvider databaseProvider;
  SystemInfoRepository(this.databaseProvider);

  Future<String> getSqliteVersion() async {
    final db = await databaseProvider.database;
    final sqliteVersionQuery = (await db.rawQuery('SELECT sqlite_version()'));
    final sqliteVersion = sqliteVersionQuery.first.values.first.toString();
    return sqliteVersion;
  }

  Future<int> getCollectionItemCount() async {
    return await getRowCount('collectionItems');
  }

  Future<int> getReleasesCount() async {
    return await getRowCount('releases');
  }

  Future<int> getRowCount(String tableName) async {
    final db = await databaseProvider.database;
    final result = await db.rawQuery('SELECT COUNT(*) FROM $tableName');
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
