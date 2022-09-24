import 'package:film_freak/models/movie_release.dart';
import 'package:film_freak/persistence/db_provider.dart';
import 'package:sqflite/sqflite.dart';

class ReleaseRepository {
  final DatabaseProvider databaseProvider;
  final String table = 'releases';
  const ReleaseRepository({required this.databaseProvider});

  Future<int> insertRelease(MovieRelease release) async {
    Database db = await databaseProvider.database;
    return await db.insert(table, release.toMap());
  }

  Future<int> queryRowCount() async {
    Database db = await databaseProvider.database;
    List<Map<String, Object?>> result =
        await db.rawQuery('SELECT COUNT(*) FROM $table');
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
