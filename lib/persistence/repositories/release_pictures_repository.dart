import 'package:film_freak/persistence/repositories/repository_base.dart';
import 'package:sqflite/sqflite.dart';

import '../../entities/release_picture.dart';
import '../db_provider.dart';

class ReleasePicturesRepository extends RepositoryBase<ReleasePicture> {
  ReleasePicturesRepository(DatabaseProvider databaseProvider)
      : super(databaseProvider, 'releasePictures');

  Future<List<int>> upsert(
      int releaseId, List<ReleasePicture> releasePictures) async {
    for (final releasePic in releasePictures) {
      releasePic.releaseId = releaseId;
    }
    final ids = <int>[];
    Database db = await databaseProvider.database;
    for (var pic in releasePictures) {
      if (pic.id != null) {
        ids.add(await db.update(tableName, pic.map, where: 'id = ${pic.id}'));
      } else {
        ids.add(await db.insert(tableName, pic.map));
      }
    }
    return ids;
  }

  Future<Iterable<ReleasePicture>> getByReleaseId(int releaseId) async {
    return super.getBy(releaseId, "releaseId", ReleasePicture.fromMap);
  }

  Future<int> deleteByReleaseId(int releaseId) async {
    return super.deleteByIdColumn(releaseId, 'releaseId');
  }
}
