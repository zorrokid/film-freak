import 'package:film_freak/entities/release_property.dart';
import 'package:film_freak/persistence/repositories/repository_base.dart';
import 'package:sqflite/sqflite.dart';

import '../db_provider.dart';

class ReleasePropertiesRepository extends RepositoryBase<ReleaseProperty> {
  ReleasePropertiesRepository(DatabaseProvider databaseProvider)
      : super(databaseProvider, 'releaseProperties');

  Future<Iterable<ReleaseProperty>> getByReleaseId(int releaseId) async {
    return super.getBy(releaseId, "releaseId", ReleaseProperty.fromMap);
  }

  Future<List<int>> upsert(
      int releaseId, List<ReleaseProperty> releaseProperties) async {
    for (final property in releaseProperties) {
      property.releaseId = releaseId;
    }
    final ids = <int>[];
    Database db = await databaseProvider.database;
    for (var prop in releaseProperties) {
      if (prop.id != null) {
        ids.add(await db.update(tableName, prop.map, where: 'id = ${prop.id}'));
      } else {
        ids.add(await db.insert(tableName, prop.map));
      }
    }
    return ids;
  }

  Future<int> deleteByReleaseId(int releaseId) async {
    return super.deleteByIdColumn(releaseId, 'releaseId');
  }
}
