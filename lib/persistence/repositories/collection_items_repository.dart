import 'package:film_freak/persistence/repositories/query_helper.dart';
import 'package:film_freak/persistence/repositories/repository_base.dart';
import 'package:sqflite/sqflite.dart';

import '../../entities/collection_item.dart';
import '../db_provider.dart';
import '../query_specs/collection_item_query_specs.dart';

class CollectionItemsRepository extends RepositoryBase<CollectionItem> {
  CollectionItemsRepository(DatabaseProvider databaseProvider)
      : super(databaseProvider, 'collectionItems');

  // TODO: generalize to base class?
  Future<Iterable<CollectionItem>> query(
      CollectionItemQuerySpecs filter) async {
    Database db = await databaseProvider.database;

    final queryArgs = QueryHelper.filterToQueryArgs(filter);
    String? orderBy = QueryHelper.getOrderBy(filter);

    final query = await db.query(tableName,
        where: queryArgs.item1,
        whereArgs: queryArgs.item2,
        orderBy: orderBy,
        limit: filter.top);

    var result =
        query.map<CollectionItem>((e) => CollectionItem.fromMap(e)).toList();
    return result;
  }
}
