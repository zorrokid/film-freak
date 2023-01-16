import 'package:sqflite/sqflite.dart';
import '../../domain/entities/release.dart';
import '../db_provider.dart';
import '../query_specs/release_query_specs.dart';
import 'query_helper.dart';
import 'repository_base.dart';

class ReleasesRepository extends RepositoryBase<Release> {
  ReleasesRepository(DatabaseProvider databaseProvider)
      : super(
          databaseProvider,
          'releases',
          Release.fromMap,
        );

  Future<int> queryRowCount() async {
    final db = await databaseProvider.database;
    final result = await db.rawQuery('SELECT COUNT(*) FROM $tableName');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // TODO: generalize to base class?
  Future<Iterable<Release>> query(ReleaseQuerySpecs? filter) async {
    final db = await databaseProvider.database;

    final queryArgs = QueryHelper.filterToQueryArgs(filter);
    String? orderBy = QueryHelper.getOrderBy(filter);

    final query = await db.query(tableName,
        where: queryArgs.item1,
        whereArgs: queryArgs.item2,
        orderBy: orderBy,
        limit: filter?.top);

    return query.map<Release>((e) => Release.fromMap(e));
  }

  Future<Iterable<Release>> getAll() async {
    final db = await databaseProvider.database;
    final query = await db.query(tableName);
    return query.map<Release>((e) => Release.fromMap(e));
  }

  Future<bool> barcodeExists(String barcode) async {
    final db = await databaseProvider.database;
    final result =
        await db.query(tableName, where: 'barcode=?', whereArgs: [barcode]);
    return result.isNotEmpty;
  }
}
