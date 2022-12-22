import 'package:film_freak/entities/release.dart';
import 'package:film_freak/enums/case_type.dart';
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

  test('Test releases repository', () async {
    final repository = ReleasesRepository(TestDatabaseProvider.instance);
    final expectedId = await repository.insert(
      Release(
        name: 'test',
        barcode: '',
        caseType: CaseType.regularDvd,
      ),
    );

    final result = await repository.get(expectedId);
    expect(expectedId, result.id);
  });
}
