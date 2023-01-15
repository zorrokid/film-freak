import 'package:film_freak/persistence/repositories/productions_repository.dart';
import 'package:film_freak/persistence/repositories/release_productions_repository.dart';

import '../entities/production.dart';
import '../entities/release_production.dart';

class ProductionService {
  final ProductionsRepository productionsRepository;
  final ReleaseProductionsRepository releaseProductionsRepository;
  ProductionService(
      {required this.productionsRepository,
      required this.releaseProductionsRepository});
  Future<Iterable<Production>> getProductionsByIds(Iterable<int> ids) async {
    final productions = await productionsRepository.getByIds(ids);
    return productions;
  }

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

  Future<void> linkProductions(
      int releaseId, Iterable<Production> productions) async {
    // TODO before returning when input productions list is empty,
    // need to ensure if prodcutions already linked to release
    // and the obsolete should be removed
    if (productions.isEmpty) return;

    assert(productions.any((element) => element.id == null) == false);

    final releaseProductions = productions.map(
        (e) => ReleaseProduction(releaseId: releaseId, productionId: e.id!));

    final existingReleaseProductions =
        await releaseProductionsRepository.getByReleaseId(releaseId);

    final productionReleaseProductionIdMap = <int, int>{};
    for (final existingProd in existingReleaseProductions) {
      productionReleaseProductionIdMap[existingProd.productionId] =
          existingProd.id!;
    }

    for (final releaseProduction in releaseProductions) {
      if (productionReleaseProductionIdMap
          .containsKey(releaseProduction.productionId)) {
        releaseProduction.id =
            productionReleaseProductionIdMap[releaseProduction.productionId];
      }
    }
  }
}
