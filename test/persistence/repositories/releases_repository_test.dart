import 'package:film_freak/domain/entities/release.dart';
import 'package:film_freak/domain/enums/case_type.dart';
import 'package:film_freak/persistence/repositories/releases_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';

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
    final repository = ReleasesRepository(TestDatabaseProvider.instance);
    final expectedId = await repository.insert(
      Release(
        name: 'test',
        barcode: '',
        caseType: CaseType.regularDvd,
        notes: 'test',
      ),
    );

    final result = await repository.get(expectedId);
    expect(expectedId, result.id);
  });

  test('Test getByIds with inserted values, returns all the inserted entities',
      () async {
    final repository = ReleasesRepository(TestDatabaseProvider.instance);
    final ids = <int>[];
    ids.add(await repository.insert(
      Release(
        name: 'test2',
        barcode: '',
        caseType: CaseType.regularDvd,
        notes: 'test',
      ),
    ));
    ids.add(await repository.insert(
      Release(
        name: 'test1',
        barcode: '',
        caseType: CaseType.regularDvd,
        notes: 'test',
      ),
    ));
    final result = await repository.getByIds(ids);
    expect(result.length, 2);
    expect(true, result.any((r) => r.id == ids[0]));
    expect(true, result.any((r) => r.id == ids[1]));
  });
}
