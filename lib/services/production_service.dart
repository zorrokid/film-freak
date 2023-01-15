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

  Future<void> updateProductionLinks(
      int releaseId, Iterable<Production> productions) async {
    // check that each production has id
    assert(productions.any((element) => element.id == null) == false);

    // check which ones are already mapped
    final existingReleaseProductions =
        await releaseProductionsRepository.getByReleaseId(releaseId);

    final existingProductionIds =
        existingReleaseProductions.map((e) => e.productionId).toSet();

    // unlink obsolete productions
    // - productions without productionId are new, they are going to be inserted
    //   no need to check those
    final currentProductionIds =
        productions.where((e) => e.id != null).map((e) => e.id).toSet();
    final productionIdsForUnlinking = <int>[];
    for (final existingProdId in existingProductionIds) {
      if (!currentProductionIds.contains(existingProdId)) {
        productionIdsForUnlinking.add(existingProdId);
      }
    }
    await releaseProductionsRepository.deleteByProductionIds(
        releaseId, productionIdsForUnlinking);

    // need to insert only those without id

    final newReleaseProductions = productions
        .where((e) =>
            existingProductionIds.contains(e.id) ==
                false // this shouldn't actually be happening
            ||
            e.id == null)
        .map(((e) =>
            ReleaseProduction(releaseId: releaseId, productionId: e.id!)));

    // now finally upsert links
    await releaseProductionsRepository.insertAll(newReleaseProductions);
  }

  Future<Iterable<ReleaseProduction>> getReleaseProductions(
      int releaseId) async {
    final releaseProductions =
        await releaseProductionsRepository.getByReleaseId(releaseId);
    return releaseProductions;
  }

  Future<Iterable<ReleaseProduction>> getReleaseProductionsByReleaseIds(
      Iterable<int> releaseIds) async {
    final releaseProductions =
        await releaseProductionsRepository.getByReleaseIds(releaseIds);
    return releaseProductions;
  }
}
