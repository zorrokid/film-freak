import 'package:film_freak/entities/movie_release.dart';
import 'package:film_freak/persistence/db_provider.dart';
import 'package:film_freak/persistence/repositories/repository_base.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tuple/tuple.dart';

import '../../models/collection_item_query_specs.dart';

class ReleaseRepository extends RepositoryBase {
  ReleaseRepository(DatabaseProvider databaseProvider)
      : super(databaseProvider, 'releases');

  Future<int> insertRelease(MovieRelease release) async {
    Database db = await databaseProvider.database;
    return await db.insert(tableName, release.map);
  }

  Future<int> updateRelease(MovieRelease release) async {
    Database db = await databaseProvider.database;
    return await db
        .update(tableName, release.map, where: 'id=?', whereArgs: [release.id]);
  }

  Future<int> queryRowCount() async {
    Database db = await databaseProvider.database;
    List<Map<String, Object?>> result =
        await db.rawQuery('SELECT COUNT(*) FROM $tableName');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<Iterable<MovieRelease>> queryReleases(
      CollectionItemQuerySpecs? filter) async {
    Database db = await databaseProvider.database;

    final queryArgs = filterToQueryArgs(filter);

    String? orderBy = getOrderBy(filter);

    final query = await db.query(tableName,
        where: queryArgs.item1,
        whereArgs: queryArgs.item2,
        orderBy: orderBy,
        limit: filter?.top);

    var result =
        query.map<MovieRelease>((e) => MovieRelease.fromMap(e)).toList();
    return result;
  }

  String? getOrderBy(CollectionItemQuerySpecs? filter) {
    if (filter == null || filter.orderBy == null) return null;
    final orderByClauses = <String>[];
    if (filter.orderBy == OrderByEnum.latest) {
      orderByClauses.add('modifiedTime DESC');
    }
    if (filter.orderBy == OrderByEnum.oldest) {
      orderByClauses.add('modifiedTime ASC');
    }
    return orderByClauses.join(', ');
  }

  Tuple2<String?, List<Object?>?> filterToQueryArgs(
      CollectionItemQuerySpecs? filter) {
    if (filter == null) return const Tuple2(null, null);

    final whereArgs = <Object?>[];
    final whereConditions = <String>[];

    if (filter.barcode != null) {
      whereConditions.add('barcode = ?');
      whereArgs.add(filter.barcode!);
    }

    if (whereConditions.isEmpty) {
      return const Tuple2(null, null);
    }

    final where = whereConditions.join(' AND ');
    return Tuple2(where, whereArgs);
  }

  Future<MovieRelease> getRelease(int id) async {
    Database db = await databaseProvider.database;
    List<Map<String, Object?>> queryResult =
        await db.query(tableName, where: 'id=?', whereArgs: [id]);
    var result = queryResult.map<MovieRelease>((e) => MovieRelease.fromMap(e));
    return result.first;
  }

  Future<bool> barcodeExists(String barcode) async {
    Database db = await databaseProvider.database;
    List<Map<String, Object?>> result =
        await db.query(tableName, where: 'barcode=?', whereArgs: [barcode]);
    return result.isNotEmpty;
  }
}
