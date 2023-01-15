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
    // need to ensure if produtions already linked to release
    // and the obsolete should be removed
    if (productions.isEmpty) return;

    // check that each production has id
    assert(productions.any((element) => element.id == null) == false);

    // create release production entites from productions
    final releaseProductions = productions.map(
        (e) => ReleaseProduction(releaseId: releaseId, productionId: e.id!));

    // check which ones are already mapped
    final existingReleaseProductions =
        await releaseProductionsRepository.getByReleaseId(releaseId);

    // create map from those existing productions
    final productionReleaseProductionIdMap = <int, int>{};
    for (final existingProd in existingReleaseProductions) {
      productionReleaseProductionIdMap[existingProd.productionId] =
          existingProd.id!;
    }

    // set release production id for those productions which are already linked
    for (final releaseProduction in releaseProductions) {
      if (productionReleaseProductionIdMap
          .containsKey(releaseProduction.productionId)) {
        releaseProduction.id =
            productionReleaseProductionIdMap[releaseProduction.productionId];
      }
    }

    // now finally upsert links
    for (final releaseProduction in releaseProductions) {
      await releaseProductionsRepository.upsert(releaseProduction);
    }
  }

  Future<void> removeObsoleteProductionLinks(
      int releaseId, Iterable<Production> productions) async {
    final existingReleaseProductions =
        await releaseProductionsRepository.getByReleaseId(releaseId);
    final existingProductionIds =
        existingReleaseProductions.map((e) => e.productionId).toSet();
    // productions without productionId are new, they are inserted, no need to check those
    final currentProductionIds = productions
        .where((element) => element.id != null)
        .map((e) => e.id)
        .toList();
    final productionIdsForUnlinking = <int>[];
    for (final existingProdId in existingProductionIds) {
      if (!currentProductionIds.contains(existingProdId)) {
        productionIdsForUnlinking.add(existingProdId);
      }
    }
    await releaseProductionsRepository.deleteByProductionIds(
        releaseId, productionIdsForUnlinking);
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
