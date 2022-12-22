import 'package:film_freak/entities/release_property.dart';
import 'package:film_freak/enums/release_property_type.dart';
import 'package:film_freak/persistence/repositories/release_properties_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../test_database_provider.dart';

Future main() async {
  // Setup sqflite_common_ffi for flutter test
  setUpAll(() async {
    // Initialize FFI
    sqfliteFfiInit();
    // Change the default factory
    databaseFactory = databaseFactoryFfi;
  });

  test('Test get with inserted value, it should return value.', () async {
    final releasePropertiesRepository =
        ReleasePropertiesRepository(TestDatabaseProvider.instance);
    const releaseId = 11;
    final releaseProperty = ReleaseProperty(
        propertyType: ReleasePropertyType.slipCover, releaseId: releaseId);

    final expectedId =
        await releasePropertiesRepository.insert(releaseProperty);

    final insertedProperty = await releasePropertiesRepository.get(expectedId);

    expect(insertedProperty.id, expectedId);
    expect(insertedProperty.releaseId, releaseId);

    final result = await releasePropertiesRepository.getByReleaseId(releaseId);
    expect(result.length, 1);
    expect(result.single.id, expectedId);
  });
}
