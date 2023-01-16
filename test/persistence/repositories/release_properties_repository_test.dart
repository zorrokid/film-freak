import 'package:film_freak/domain/entities/release_property.dart';
import 'package:film_freak/domain/enums/release_property_type.dart';
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

  tearDown(() async {
    final db = await TestDatabaseProvider.instance.database;
    db.delete('releaseProperties');
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
  });

  test('Test getByReleaseId with release id value, it should return value.',
      () async {
    final releasePropertiesRepository =
        ReleasePropertiesRepository(TestDatabaseProvider.instance);
    const releaseId = 11;
    final releaseProperty = ReleaseProperty(
        propertyType: ReleasePropertyType.slipCover, releaseId: releaseId);

    final expectedId =
        await releasePropertiesRepository.insert(releaseProperty);
    final result = await releasePropertiesRepository.getByReleaseId(releaseId);
    expect(result.length, 1);
    expect(result.single.releaseId, releaseId);
    expect(result.single.id, expectedId);
  });

  test('Delete obsolete childs', () async {
    final releasePropertiesRepository =
        ReleasePropertiesRepository(TestDatabaseProvider.instance);
    const releaseId = 11;
    final releaseProperty1 = ReleaseProperty(
        propertyType: ReleasePropertyType.slipCover, releaseId: releaseId);
    final releaseProperty2 = ReleaseProperty(
        propertyType: ReleasePropertyType.hologramCover, releaseId: releaseId);

    final expectedId =
        await releasePropertiesRepository.insert(releaseProperty1);
    final _ = await releasePropertiesRepository.insert(releaseProperty2);

    final properties =
        await releasePropertiesRepository.getByReleaseId(releaseId);
    expect(properties.length, 2);

    final property1fromDb =
        properties.where((element) => element.id == expectedId).single;

    final newListOfProperties = <ReleaseProperty>[property1fromDb];

    await releasePropertiesRepository.deleteObsoletedChilds(
        releaseId, newListOfProperties);

    final propertiesNew =
        await releasePropertiesRepository.getByReleaseId(releaseId);
    expect(propertiesNew.length, 1);
    expect(propertiesNew.first.id, expectedId);
  });
}
