import 'package:sqflite/sqflite.dart';

import '../../entities/entity.dart';
import '../db_provider.dart';
import 'repository_base.dart';

abstract class ReleaseChildEntitiesRepository<T extends ReleaseChildEntity>
    extends RepositoryBase<T> {
  ReleaseChildEntitiesRepository(
      DatabaseProvider databaseProvider, String databaseName)
      : super(databaseProvider, databaseName);

  Future<List<int>> upsert(int releaseId, List<T> releaseChilds) async {
    for (final releaseChild in releaseChilds) {
      releaseChild.releaseId = releaseId;
    }
    final ids = <int>[];
    Database db = await databaseProvider.database;
    for (var child in releaseChilds) {
      if (child.id != null) {
        ids.add(
            await db.update(tableName, child.map, where: 'id = ${child.id}'));
      } else {
        ids.add(await db.insert(tableName, child.map));
      }
    }
    return ids;
  }

  Future<Iterable<T>> getByReleaseId(int releaseId, Function mapper) async {
    return super.getById(releaseId, "releaseId", mapper);
  }

  Future<int> deleteByReleaseId(int releaseId) async {
    return super.deleteByIdColumn(releaseId, 'releaseId');
  }
}
