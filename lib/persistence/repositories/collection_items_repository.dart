import 'query_helper.dart';
import 'release_child_entities_repository.dart';
import '../../domain/entities/collection_item.dart';
import '../db_provider.dart';
import '../query_specs/collection_item_query_specs.dart';

class CollectionItemsRepository
    extends ReleaseChildEntitiesRepository<CollectionItem> {
  CollectionItemsRepository(DatabaseProvider databaseProvider)
      : super(
          databaseProvider,
          'collectionItems',
          CollectionItem.fromMap,
        );

  // TODO: generalize to base class?
  Future<Iterable<CollectionItem>> query(
      // TODO QuerySpecs<T> ?
      CollectionItemQuerySpecs filter) async {
    final db = await databaseProvider.database;
    // TODO filter.queryArgs
    final queryArgs = QueryHelper.filterToQueryArgs(filter);
    // TODO filter.orderBy
    String? orderBy = QueryHelper.getOrderBy(filter);

    final query = await db.query(tableName,
        where: queryArgs.item1,
        whereArgs: queryArgs.item2,
        orderBy: orderBy,
        limit: filter.top);

    return query.map<CollectionItem>((e) => mapper(e)).toList();
  }
}
