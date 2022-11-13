import 'package:sqflite/sqflite.dart';

import '../models/release_picture.dart';
import 'db_provider.dart';

class ReleasePicturesRepository {
  final DatabaseProvider databaseProvider;
  final String table = 'releasePictures';
  const ReleasePicturesRepository({required this.databaseProvider});

  Future<List<int>> upsert(List<ReleasePicture> releasePictures) async {
    final ids = <int>[];
    Database db = await databaseProvider.database;
    for (var pic in releasePictures) {
      if (pic.id != null) {
        ids.add(await db.update(table, pic.map, where: 'id = ${pic.id}'));
      } else {
        ids.add(await db.insert(table, pic.map));
      }
    }
    return ids;
  }

  Future<Iterable<ReleasePicture>> getByRelease(int releaseId) async {
    Database db = await databaseProvider.database;
    List<Map<String, Object?>> queryResult =
        await db.rawQuery('SELECT * FROM $table WHERE releaseId = $releaseId');
    var result =
        queryResult.map<ReleasePicture>((e) => ReleasePicture.fromMap(e));
    return result;
  }

  Future<int> delete(int picId) async {
    Database db = await databaseProvider.database;
    return await db.delete(table, where: 'id = $picId');
  }
}
