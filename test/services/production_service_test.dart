import 'package:film_freak/entities/production.dart';
import 'package:film_freak/enums/production_type.dart';
import 'package:film_freak/persistence/repositories/productions_repository.dart';
import 'package:film_freak/persistence/repositories/release_productions_repository.dart';
import 'package:film_freak/services/production_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../persistence/test_database_provider.dart';

Future main() async {
  late ProductionService productionService;
  // Setup sqflite_common_ffi for flutter test
  setUpAll(() async {
    // Initialize FFI
    sqfliteFfiInit();
    // Change the default factory
    databaseFactory = databaseFactoryFfi;
    productionService = ProductionService(
      productionsRepository:
          ProductionsRepository(TestDatabaseProvider.instance),
      releaseProductionsRepository:
          ReleaseProductionsRepository(TestDatabaseProvider.instance),
    );
  });

  tearDown(() async {
    final db = await TestDatabaseProvider.instance.database;
    db.delete('productions');
  });

  test('No existing production, production is inserted and populated with id.',
      () async {
    final testProduction = Production(
      productionType: ProductionType.movie,
      title: 'A Movie',
      originalTitle: 'Elokuva',
      tmdbId: 123,
    );

    final productions = <Production>[testProduction];
    await productionService.upsertProductions(productions);
    expect(testProduction.id != null, true);
  });

  test(
      'Has existing production with matching tmdb id, production is linked and populated with id.',
      () async {
    final db = await TestDatabaseProvider.instance.database;

    final testProduction = Production(
      productionType: ProductionType.movie,
      title: 'A Movie',
      originalTitle: 'Elokuva',
      tmdbId: 123,
    );

    final id = await db.insert('productions', testProduction.map);

    final productions = <Production>[testProduction];
    await productionService.upsertProductions(productions);
    expect(testProduction.id == id, true);
  });
}
