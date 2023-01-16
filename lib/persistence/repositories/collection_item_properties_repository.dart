import '../db_provider.dart';
import '../../domain/entities/collection_item_property.dart';
import 'collection_item_child_entities_repository.dart';

class CollectionItemPropertiesRepository
    extends CollectionItemChildEntitiesRepository<CollectionItemProperty> {
  CollectionItemPropertiesRepository(DatabaseProvider databaseProvider)
      : super(
          databaseProvider,
          'collectionItemProperties',
          CollectionItemProperty.fromMap,
        );
}
