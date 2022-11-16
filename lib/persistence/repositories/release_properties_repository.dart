import 'package:film_freak/entities/release_property.dart';
import 'package:film_freak/persistence/repositories/repository_base.dart';
import 'package:sqflite/sqflite.dart';

import '../../enums/release_property_type.dart';
import '../db_provider.dart';

class ReleasePropertiesRepository extends RepositoryBase<ReleaseProperty> {
  ReleasePropertiesRepository(DatabaseProvider databaseProvider)
      : super(databaseProvider, 'releaseProperties');

  Future<Iterable<ReleaseProperty>> getByReleaseId(int releaseId) async {
    return super.getBy(releaseId, "releaseId", fromMap);
  }

  ReleaseProperty fromMap(Map<String, Object?> map) {
    return ReleaseProperty(
      map['releaseId'] as int,
      id: map['id'] as int,
      propertyType: ReleasePropertyType.values[map['propertyType'] as int],
      createdTime: DateTime.parse(map['createdTime'] as String),
      modifiedTime: DateTime.parse(map['modifiedTime'] as String),
    );
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
}
