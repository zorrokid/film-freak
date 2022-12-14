import 'package:sqflite/sqflite.dart';

import '../../entities/entity.dart';
import '../db_provider.dart';
import 'repository_base.dart';

abstract class ReleaseChildEntitiesRepository<T extends ReleaseChildEntity>
    extends RepositoryBase<T> {
  Function mapper;
  ReleaseChildEntitiesRepository(
      DatabaseProvider databaseProvider, String databaseName,
      {required this.mapper})
      : super(databaseProvider, databaseName);

  Future<List<int>> upsert(int releaseId, Iterable<T> releaseChilds) async {
    _deleteObsoletedChilds(releaseId, releaseChilds);

    // ensure parent relation is set
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

  Future<Iterable<T>> getByReleaseId(int releaseId) async {
    return super.getById(releaseId, "releaseId", mapper);
  }

  Future<Iterable<T>> getByReleaseIds(Iterable<int> releaseids) async {
    Database db = await databaseProvider.database;
    final query = await db.query(tableName,
        where: 'releaseId IN (?)', whereArgs: [releaseids.join(',')]);
    final result = query.map<T>((e) => mapper(e));
    return result;
  }

  Future<int> deleteByReleaseId(int releaseId) async {
    return super.deleteByIdColumn(releaseId, 'releaseId');
  }

  Future<void> _deleteObsoletedChilds(
      int releaseId, Iterable<T> releaseChilds) async {
    final originalChildsInDb = await getByReleaseId(releaseId);
    final modifiedChildIds = releaseChilds.map((e) => e.id);
    final childIdsToBeDeleted =
        originalChildsInDb.where((e) => !modifiedChildIds.contains(e.id));
    for (final child in childIdsToBeDeleted) {
      await super.delete(child.id!);
    }
  }
}
