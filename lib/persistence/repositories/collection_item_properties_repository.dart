import 'package:film_freak/entities/release_property.dart';
import '../db_provider.dart';
import '../../entities/collection_item_property.dart';
import 'collection_item_child_entities_repository.dart';

class CollectionItemPropertiesRepository
    extends CollectionItemChildEntitiesRepository<CollectionItemProperty> {
  CollectionItemPropertiesRepository(DatabaseProvider databaseProvider)
      : super(databaseProvider, 'collectionItemProperties');
}
