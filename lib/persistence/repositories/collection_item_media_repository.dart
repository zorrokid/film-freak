import 'package:film_freak/persistence/repositories/collection_item_child_entities_repository.dart';

import '../../entities/collection_item_media.dart';
import '../db_provider.dart';

class CollectionItemMediaRepository
    extends CollectionItemChildEntitiesRepository<CollectionItemMedia> {
  CollectionItemMediaRepository(DatabaseProvider databaseProvider)
      : super(databaseProvider, 'collectionItemMedias',
            CollectionItemMedia.fromMap);
}
