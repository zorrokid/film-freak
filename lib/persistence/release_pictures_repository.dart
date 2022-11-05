import 'package:sqflite/sqflite.dart';

import '../models/release_picture.dart';
import 'db_provider.dart';

class ReleasePicturesRepository {
  final DatabaseProvider databaseProvider;
  final String table = 'releasePictures';
  const ReleasePicturesRepository({required this.databaseProvider});

  Future<int> insert(ReleasePicture releasePicture) async {
    Database db = await databaseProvider.database;
    return await db.insert(table, releasePicture.map);
  }

  Future<Iterable<ReleasePicture>> getByRelease(int releaseId) async {
    Database db = await databaseProvider.database;
    List<Map<String, Object?>> queryResult =
        await db.rawQuery('SELECT * FROM $table WHERE releaseId = $releaseId');
    var result =
        queryResult.map<ReleasePicture>((e) => ReleasePicture.fromMap(e));
    return result;
  }
}
