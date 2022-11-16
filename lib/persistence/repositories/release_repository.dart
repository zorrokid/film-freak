import 'package:film_freak/entities/movie_release.dart';
import 'package:film_freak/persistence/db_provider.dart';
import 'package:film_freak/persistence/repositories/repository_base.dart';
import 'package:sqflite/sqflite.dart';

import '../../enums/case_type.dart';
import '../../enums/condition.dart';
import '../../enums/media_type.dart';

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
    var result = queryResult.map<MovieRelease>((e) => fromMap(e));
    return result;
  }

  Future<MovieRelease> getRelease(int id) async {
    Database db = await databaseProvider.database;
    List<Map<String, Object?>> queryResult =
        await db.rawQuery("SELECT * FROM $tableName WHERE id='$id'");
    var result = queryResult.map<MovieRelease>((e) => fromMap(e));
    return result.first;
  }

  Future<bool> barcodeExists(String barcode) async {
    Database db = await databaseProvider.database;
    List<Map<String, Object?>> result = await db
        .rawQuery("SELECT COUNT(*) FROM $tableName WHERE barcode='$barcode'");
    return Sqflite.firstIntValue(result)! > 0;
  }

  MovieRelease fromMap(Map<String, Object?> map) {
    return MovieRelease(
        id: map['id'] as int,
        name: map['name'] as String,
        mediaType: MediaType.values[map['mediaType'] as int],
        barcode: map['barcode'] as String,
        caseType: CaseType.values[map['caseType'] as int],
        condition: Condition.values[map['condition'] as int],
        notes: map['notes'] as String,
        createdTime: DateTime.parse(map['createdTime'] as String),
        modifiedTime: DateTime.parse(map['modifiedTime'] as String),
        hasSlipCover: (map['hasSlipCover'] as int) == 1 ? true : false);
  }
}
