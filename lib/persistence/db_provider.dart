import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const String initSql =
    'CREATE TABLE releases(id INTEGER PRIMARY KEY, name TEXT, barcode TEXT)';
const String dbName = 'film_freak_database.db';
const int dbVersion = 1;

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
    final database =
        openDatabase(path, onCreate: _onCreate, version: dbVersion);
    return database;
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(initSql);
  }
}
