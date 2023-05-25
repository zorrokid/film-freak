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
}
