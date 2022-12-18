import 'repository_base.dart';
import '../../entities/production.dart';
import '../db_provider.dart';

class ProductionsRepository extends RepositoryBase<Production> {
  ProductionsRepository(DatabaseProvider databaseProvider)
      : super(
          databaseProvider,
          'productions',
          Production.fromMap,
        );

  Future<Production?> getByTmdbId(int id) async {
    final res = await getById(id, 'tmdbId');
    return res.isNotEmpty ? res.first : null;
  }
}
