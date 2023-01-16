import '../../domain/entities/release_production.dart';
import '../db_provider.dart';
import 'release_child_entities_repository.dart';

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

  Future<void> insertAll(Iterable<ReleaseProduction> releaseProductions) async {
    final db = await databaseProvider.database;
    final batch = db.batch();
    for (final releaseProduction in releaseProductions) {
      batch.insert(tableName, releaseProduction.map);
    }
    await batch.commit(noResult: true);
  }
}
