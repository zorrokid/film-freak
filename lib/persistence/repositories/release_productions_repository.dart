import 'package:film_freak/entities/release_production.dart';
import 'package:film_freak/persistence/db_provider.dart';
import 'package:film_freak/persistence/repositories/release_child_entities_repository.dart';

// TODO: tarvitsee oman toteutuksen koska many-to-many ja id sijaan productionId
class ReleaseProductionsRepository
    extends ReleaseChildEntitiesRepository<ReleaseProduction> {
  ReleaseProductionsRepository(DatabaseProvider databaseProvider)
      : super(
          databaseProvider,
          'releaseProductions',
          ReleaseProduction.fromMap,
        );
}
