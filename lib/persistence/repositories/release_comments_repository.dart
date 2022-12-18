import '../db_provider.dart';
import '../../entities/release_comment.dart';
import 'release_child_entities_repository.dart';

class ReleaseCommentsRepository
    extends ReleaseChildEntitiesRepository<ReleaseComment> {
  ReleaseCommentsRepository(DatabaseProvider databaseProvider)
      : super(
          databaseProvider,
          'releaseComments',
          ReleaseComment.fromMap,
        );
}
