import '../db_provider.dart';
import '../../domain/entities/release_media.dart';
import 'release_child_entities_repository.dart';

class ReleaseMediasRepository
    extends ReleaseChildEntitiesRepository<ReleaseMedia> {
  ReleaseMediasRepository(DatabaseProvider databaseProvider)
      : super(
          databaseProvider,
          'releaseMedias',
          ReleaseMedia.fromMap,
        );
}
