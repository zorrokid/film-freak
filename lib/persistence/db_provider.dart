import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'migrations.dart';

const String dbName = 'film_freak_db_1.db';

abstract class DatabaseProvider {
  Future<Database> get database;
  Future<bool> truncateDb();
}

class DatabaseProviderSqflite extends DatabaseProvider {
  // singleton class
  DatabaseProviderSqflite._privateConstructor();
  static final DatabaseProvider instance =
      DatabaseProviderSqflite._privateConstructor();

  static Database? _database;

  @override
  Future<Database> get database async {
    return _database ??= await _initialize();
  }

  Future<Database> _initialize() async {
    String path = join(await getDatabasesPath(), dbName);

    if (migrationScripts.isNotEmpty) {
      final dbVersion = migrationScripts.keys.last;
      final database =
          openDatabase(path, version: dbVersion, onUpgrade: _onUpgrade);
      return database;
    } else {
      final database = openDatabase(path, onCreate: _onCreate, version: 1);
      return database;
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    if (!migrationScripts.containsKey(version)) {
      throw Exception('Migration for version $version missing!');
    }
    await db.execute(migrationScripts[version]!);
    final setVersionCommand = 'PRAGMA user_version=$version';
    await db.execute(setVersionCommand);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    for (var entry in migrationScripts.entries) {
      if (entry.key <= oldVersion || entry.key > newVersion) continue;
      await db.execute(entry.value);
      final setVersionCommand = 'PRAGMA user_version=${entry.key}';
      await db.execute(setVersionCommand);
    }
  }

  Future<bool> truncateDb() async {
    await _database?.close();
    final path = join(await getDatabasesPath(), dbName);
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
      _database = null;
      return true;
    }
    return false;
  }
}
