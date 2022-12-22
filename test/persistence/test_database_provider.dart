import 'package:film_freak/persistence/db_provider.dart';
import 'package:film_freak/persistence/migrations.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

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
