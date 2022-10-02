import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'migrations.dart';

const String dbName = 'film_freak_db_1.db';

class DatabaseProvider {
  // singleton class
  DatabaseProvider._privateConstructor();
  static final DatabaseProvider instance =
      DatabaseProvider._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    return _database ??= await _initialize();
  }

  Future<Database> _initialize() async {
    String path = join(await getDatabasesPath(), dbName);

    if (migrationScripts.isNotEmpty) {
      var dbVersion = migrationScripts.keys.last;
      final database =
          openDatabase(path, version: dbVersion, onUpgrade: _onUpgrade);
      return database;
    } else {
      final database = openDatabase(path, onCreate: _onCreate, version: 1);
      return database;
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(initialCreate);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // List<Map<String, Object?>> migrationHistoryVersionResult =
    //     await db.rawQuery('''SELECT PRAGMA user_version''');
    // var currentVersion =
    //     Sqflite.firstIntValue(migrationHistoryVersionResult) ?? 0;

    for (var entry in migrationScripts.entries) {
      if (entry.key <= oldVersion) continue;
      await db.execute(entry.value);
      // await db.execute(
      //     '''INSERT INTO migration_history (version) values (${entry.key})''');
    }
  }
}
