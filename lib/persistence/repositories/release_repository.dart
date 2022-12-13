import 'package:film_freak/entities/release.dart';
import 'package:film_freak/persistence/db_provider.dart';
import 'package:film_freak/persistence/repositories/query_helper.dart';
import 'package:film_freak/persistence/repositories/repository_base.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/collection_item_query_specs.dart';

class ReleaseRepository extends RepositoryBase<Release> {
  ReleaseRepository(DatabaseProvider databaseProvider)
      : super(databaseProvider, 'releases');

  Future<int> queryRowCount() async {
    Database db = await databaseProvider.database;
    List<Map<String, Object?>> result =
        await db.rawQuery('SELECT COUNT(*) FROM $tableName');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // TODO: generalize to base class?
  Future<Iterable<Release>> query(CollectionItemQuerySpecs? filter) async {
    Database db = await databaseProvider.database;

    final queryArgs = QueryHelper.filterToQueryArgs(filter);
    String? orderBy = QueryHelper.getOrderBy(filter);

    final query = await db.query(tableName,
        where: queryArgs.item1,
        whereArgs: queryArgs.item2,
        orderBy: orderBy,
        limit: filter?.top);

    var result = query.map<Release>((e) => Release.fromMap(e));
    return result;
  }

  Future<Iterable<Release>> getByIds(Iterable<int> ids) async {
    Database db = await databaseProvider.database;
    List<Map<String, Object?>> queryResult = await db
        .query(tableName, where: 'id IN (?)', whereArgs: [ids.join(',')]);
    return queryResult.map<Release>((e) => Release.fromMap(e)).toList();
  }

  Future<bool> barcodeExists(String barcode) async {
    Database db = await databaseProvider.database;
    List<Map<String, Object?>> result =
        await db.query(tableName, where: 'barcode=?', whereArgs: [barcode]);
    return result.isNotEmpty;
  }
}
