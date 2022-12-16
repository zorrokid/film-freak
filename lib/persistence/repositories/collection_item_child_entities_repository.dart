import 'package:sqflite/sqflite.dart';

import '../../entities/entity.dart';
import '../db_provider.dart';
import 'repository_base.dart';

abstract class CollectionItemChildEntitiesRepository<
    T extends CollectionItemChildEntity> extends RepositoryBase<T> {
  CollectionItemChildEntitiesRepository(
      DatabaseProvider databaseProvider, String databaseName, Function mapper)
      : super(databaseProvider, databaseName, mapper);

  Future<List<int>> upsert(int collectionItemId, List<T> childs) async {
    for (final child in childs) {
      child.collectionItemId = collectionItemId;
    }
    final ids = <int>[];
    Database db = await databaseProvider.database;
    for (var child in childs) {
      if (child.id != null) {
        ids.add(
            await db.update(tableName, child.map, where: 'id = ${child.id}'));
      } else {
        ids.add(await db.insert(tableName, child.map));
      }
    }
    return ids;
  }

  Future<Iterable<T>> getByCollectionItemId(int collectionItemId) async {
    return super.getById(collectionItemId, "collectionItemId");
  }

  Future<int> deleteByCollectionItemId(int collectionItemId) async {
    return super.deleteByIdColumn(collectionItemId, 'collectionItemId');
  }
}
