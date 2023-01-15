import 'package:film_freak/persistence/repositories/productions_repository.dart';

import '../entities/production.dart';

class ProductionService {
  final ProductionsRepository productionsRepository;
  ProductionService({required this.productionsRepository});
  Future<void> upsertProductions(Iterable<Production> productions) async {
    if (productions.isEmpty) return;

    for (final production in productions) {
      // check if production entry with tmdb id already exists and assign id if it does
      if (production.id == null && production.tmdbId != null) {
        final existingProduction =
            await productionsRepository.getByTmdbId(production.tmdbId!);
        if (existingProduction != null) {
          production.id = existingProduction.id;
        }
      }

      final productionId = await productionsRepository.upsert(production);
      production.id = productionId;
    }
  }
}
