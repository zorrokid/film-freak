import 'package:film_freak/entities/release_property.dart';
import 'package:film_freak/persistence/repositories/repository_base.dart';

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
      id: map['id'] as int,
      releaseId: map['releaseId'] as int,
      propertyType: ReleasePropertyType.values[map['propertyType'] as int],
      createdTime: DateTime.parse(map['createdTime'] as String),
      modifiedTime: DateTime.parse(map['modifiedTime'] as String),
    );
  }
}
