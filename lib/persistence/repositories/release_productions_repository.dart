import 'package:film_freak/entities/release_production.dart';
import 'package:film_freak/persistence/db_provider.dart';
import 'package:film_freak/persistence/repositories/release_child_entities_repository.dart';

class ReleaseProductionsRepository
    // this shouldn't be probably extended from the following since
    // this is n:m and the usual case is 1:n and deleteObsoleteChilds cannot be used
    extends ReleaseChildEntitiesRepository<ReleaseProduction> {
  ReleaseProductionsRepository(DatabaseProvider databaseProvider)
      : super(
          databaseProvider,
          'releaseProductions',
          ReleaseProduction.fromMap,
        );

  Future<void> deleteByProductionIds(
      int releaseId, Iterable<int> productionIds) async {
    final db = await databaseProvider.database;
    final batch = db.batch();
    for (final prodId in productionIds) {
      batch.delete(tableName,
          where: 'productionId = ? AND releaseId = ?',
          whereArgs: [prodId, releaseId]);
    }
    await batch.commit(noResult: true);
  }

//  @override
//  Future<void> deleteObsoletedChilds(
//    int releaseId,
//    Iterable<ReleaseParroduction> releaseChilds,
//  ) async {
//    final Iterable<ReleaseProduction> originalChildsInDb =
//        await getByReleaseId(releaseId);
//    final Iterable<int> modifiedChildIds =
//        releaseChilds.map((e) => e.productionId);
//    final Iterable<ReleaseProduction> childIdsToBeDeleted = originalChildsInDb
//        .where((e) => !modifiedChildIds.contains(e.productionId));
//    for (final child in childIdsToBeDeleted) {
//      await super.delete(child.id!);
//    }
//  }
}
