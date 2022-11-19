import 'package:film_freak/entities/movie_release.dart';
import 'package:film_freak/persistence/db_provider.dart';
import 'package:film_freak/persistence/repositories/repository_base.dart';
import 'package:sqflite/sqflite.dart';

class ReleaseRepository extends RepositoryBase {
  ReleaseRepository(DatabaseProvider databaseProvider)
      : super(databaseProvider, 'releases');

  Future<int> insertRelease(MovieRelease release) async {
    Database db = await databaseProvider.database;
    return await db.insert(tableName, release.map);
  }

  Future<int> updateRelease(MovieRelease release) async {
    Database db = await databaseProvider.database;
    return await db
        .update(tableName, release.map, where: 'id=?', whereArgs: [release.id]);
  }

  Future<int> queryRowCount() async {
    Database db = await databaseProvider.database;
    List<Map<String, Object?>> result =
        await db.rawQuery('SELECT COUNT(*) FROM $tableName');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<Iterable<MovieRelease>> queryReleases() async {
    Database db = await databaseProvider.database;
    List<Map<String, Object?>> queryResult =
        await db.rawQuery('SELECT * FROM $tableName');
    var result = queryResult.map<MovieRelease>((e) => MovieRelease.fromMap(e));
    return result;
  }

  Future<MovieRelease> getRelease(int id) async {
    Database db = await databaseProvider.database;
    List<Map<String, Object?>> queryResult =
        await db.rawQuery("SELECT * FROM $tableName WHERE id='$id'");
    var result = queryResult.map<MovieRelease>((e) => MovieRelease.fromMap(e));
    return result.first;
  }

  Future<bool> barcodeExists(String barcode) async {
    Database db = await databaseProvider.database;
    List<Map<String, Object?>> result = await db
        .rawQuery("SELECT COUNT(*) FROM $tableName WHERE barcode='$barcode'");
    return Sqflite.firstIntValue(result)! > 0;
  }
}
