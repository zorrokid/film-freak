import 'package:film_freak/entities/release_production.dart';
import 'package:film_freak/persistence/db_provider.dart';
import 'package:film_freak/persistence/repositories/release_child_entities_repository.dart';

class ReleaseProductionsRepository
    extends ReleaseChildEntitiesRepository<ReleaseProduction> {
  ReleaseProductionsRepository(DatabaseProvider databaseProvider)
      : super(
          databaseProvider,
          'releaseProductions',
          ReleaseProduction.fromMap,
        );

//  @override
//  Future<void> deleteObsoletedChilds(
//    int releaseId,
//    Iterable<ReleaseProduction> releaseChilds,
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
