import 'package:film_freak/persistence/repositories/repository_base.dart';
import 'package:sqflite/sqflite.dart';

import '../../entities/production.dart';
import '../db_provider.dart';

class MovieRepository extends RepositoryBase<Production> {
  MovieRepository(DatabaseProvider databaseProvider)
      : super(databaseProvider, 'movies');

  Future<int> upsert(Production movie) async {
    Database db = await databaseProvider.database;
    int? id = movie.id;
    if (id != null) {
      await db.update(tableName, movie.map, where: 'id=?', whereArgs: [id]);
      return id;
    }
    return await db.insert(tableName, movie.map);
  }

  Future<Production?> getByTmdbId(int id) async {
    final res = await getById(id, 'tmdbId', Production.fromMap);
    return res.isNotEmpty ? res.first : null;
  }

  Future<Iterable<Production>> getByIds(Iterable<int> ids) async {
    Database db = await databaseProvider.database;
    final query = await db
        .query(tableName, where: 'id IN (?)', whereArgs: [ids.join(',')]);
    final result = query.map<Production>((e) => Production.fromMap(e));
    return result;
  }
}
