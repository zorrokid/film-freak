import 'package:film_freak/persistence/repositories/repository_base.dart';
import 'package:sqflite/sqflite.dart';

import '../../entities/release_picture.dart';
import '../../enums/picture_type.dart';
import '../db_provider.dart';

class ReleasePicturesRepository extends RepositoryBase<ReleasePicture> {
  ReleasePicturesRepository(DatabaseProvider databaseProvider)
      : super(databaseProvider, 'releasePictures');

  Future<List<int>> upsert(List<ReleasePicture> releasePictures) async {
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
    return super.getBy(releaseId, "releaseId", fromMap);
  }

  Future<int> delete(int picId) async {
    Database db = await databaseProvider.database;
    return await db.delete(tableName, where: 'id = $picId');
  }

  ReleasePicture fromMap(Map<String, dynamic> map) {
    return ReleasePicture(
        id: map['id'] as int,
        releaseId: map['releaseId'] as int,
        filename: map['filename'],
        pictureType: PictureType.values[map['pictureType'] as int]);
  }
}