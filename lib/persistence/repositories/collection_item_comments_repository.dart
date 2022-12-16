import '../../entities/collection_item_comment.dart';
import '../db_provider.dart';
import 'collection_item_child_entities_repository.dart';

class CollectionItemCommentsRepository
    extends CollectionItemChildEntitiesRepository<CollectionItemComment> {
  CollectionItemCommentsRepository(DatabaseProvider databaseProvider)
      : super(
          databaseProvider,
          'collectionItemComments',
          CollectionItemComment.fromMap,
        );
}
