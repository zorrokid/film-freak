import 'package:film_freak/entities/release.dart';
import 'package:film_freak/enums/case_type.dart';
import 'package:film_freak/persistence/db_provider.dart';
import 'package:film_freak/persistence/migrations.dart';
import 'package:film_freak/persistence/repositories/releases_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';

class TestDatabaseProvider extends DatabaseProvider {
  TestDatabaseProvider._privateConstructor();
  static final TestDatabaseProvider instance =
      TestDatabaseProvider._privateConstructor();
  static Database? _database;

  @override
  Future<Database> get database async {
    return _database ??= await _initialize();
  }

  Future<Database> _initialize() async {
    sqfliteFfiInit();
    // Change the default factory
    databaseFactory = databaseFactoryFfi;
    final database = await openDatabase(inMemoryDatabasePath,
        onCreate: _onCreate, version: 1);
    return database;
  }

  Future<void> _onCreate(Database db, int version) async {
    for (final k in migrationScripts.keys) {
      await db.execute(migrationScripts[k]!);
    }
  }

  @override
  Future<bool> truncateDb() {
    // TODO: implement truncateDb
    throw UnimplementedError();
  }
}

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
