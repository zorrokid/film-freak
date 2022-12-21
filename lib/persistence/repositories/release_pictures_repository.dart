import 'package:sqflite/sqflite.dart';

import '../../entities/release_picture.dart';
import '../../enums/picture_type.dart';
import '../db_provider.dart';
import 'release_child_entities_repository.dart';

class ReleasePicturesRepository
    extends ReleaseChildEntitiesRepository<ReleasePicture> {
  ReleasePicturesRepository(DatabaseProvider databaseProvider)
      : super(
          databaseProvider,
          'releasePictures',
          ReleasePicture.fromMap,
        );

  Future<Iterable<ReleasePicture>> getByReleaseIdsAndPicType(
      Iterable<int> releaseids, Iterable<PictureType> picTypes) async {
    Database db = await databaseProvider.database;
    final query = await db.query(tableName,
        where: 'releaseId IN (?) AND pictureType IN (?)',
        whereArgs: [
          // TODO these propably won't work
          releaseids.join(','),
          picTypes.map((e) => e.index).join(',')
        ]);
    final result = query.map<ReleasePicture>((e) => ReleasePicture.fromMap(e));
    return result;
  }
}
