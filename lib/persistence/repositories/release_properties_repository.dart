import 'package:film_freak/entities/release_property.dart';
import '../db_provider.dart';
import 'release_child_entities_repository.dart';

class ReleasePropertiesRepository
    extends ReleaseChildEntitiesRepository<ReleaseProperty> {
  ReleasePropertiesRepository(DatabaseProvider databaseProvider)
      : super(
          databaseProvider,
          'releaseProperties',
          ReleaseProperty.fromMap,
        );
}
