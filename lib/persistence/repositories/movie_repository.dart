import 'package:film_freak/persistence/repositories/repository_base.dart';
import 'package:sqflite/sqflite.dart';

import '../../entities/movie.dart';
import '../db_provider.dart';

class MovieRepository extends RepositoryBase<Movie> {
  MovieRepository(DatabaseProvider databaseProvider)
      : super(databaseProvider, 'movies');

  Future<int> upsert(Movie movie) async {
    Database db = await databaseProvider.database;
    int? id = movie.id;
    if (id != null) {
      await db.update(tableName, movie.map, where: 'id=?', whereArgs: [id]);
      return id;
    }
    return await db.insert(tableName, movie.map);
  }
}
