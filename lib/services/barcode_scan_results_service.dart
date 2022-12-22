import 'package:film_freak/persistence/query_specs/release_query_specs.dart';

import '../entities/production.dart';
import '../entities/release.dart';
import '../entities/release_picture.dart';
import '../enums/media_type.dart';
import '../enums/picture_type.dart';
import '../persistence/db_provider.dart';
import '../persistence/repositories/collection_items_repository.dart';
import '../persistence/repositories/productions_repository.dart';
import '../persistence/repositories/release_comments_repository.dart';
import '../persistence/repositories/release_medias_repository.dart';
import '../persistence/repositories/release_pictures_repository.dart';
import '../persistence/repositories/release_productions_repository.dart';
import '../persistence/repositories/release_properties_repository.dart';
import '../persistence/repositories/releases_repository.dart';

enum BarcodeScanResultType {
  release,
  collectionItem,
}

class BarcodeScanResult {
  BarcodeScanResultType type;
  String description;
  int? collectionItemId;
  int releaseId;
  String? picFilename;
  BarcodeScanResult({
    required this.type,
    required this.description,
    required this.releaseId,
    this.collectionItemId,
    this.picFilename,
  });
}

BarcodeScanResultsService initializeBarcodeScanResultsService() {
  final dbProvider = DatabaseProviderSqflite.instance;
  return BarcodeScanResultsService(
    releaseRepository: ReleasesRepository(dbProvider),
    releasePicturesRepository: ReleasePicturesRepository(dbProvider),
    releasePropertiesRepository: ReleasePropertiesRepository(dbProvider),
    productionsRepository: ProductionsRepository(dbProvider),
    releaseProductionsRepository: ReleaseProductionsRepository(dbProvider),
    releaseMediasRepository: ReleaseMediasRepository(dbProvider),
    releaseCommentsRepository: ReleaseCommentsRepository(dbProvider),
    collectionItemsRepository: CollectionItemsRepository(dbProvider),
  );
}

class BarcodeScanResultsService {
  final ReleasesRepository releaseRepository;
  final ReleasePicturesRepository releasePicturesRepository;
  final ReleasePropertiesRepository releasePropertiesRepository;
  final ProductionsRepository productionsRepository;
  final ReleaseProductionsRepository releaseProductionsRepository;
  final ReleaseMediasRepository releaseMediasRepository;
  final ReleaseCommentsRepository releaseCommentsRepository;
  final CollectionItemsRepository collectionItemsRepository;

  BarcodeScanResultsService({
    required this.releaseRepository,
    required this.releasePicturesRepository,
    required this.releasePropertiesRepository,
    required this.productionsRepository,
    required this.releaseProductionsRepository,
    required this.releaseMediasRepository,
    required this.releaseCommentsRepository,
    required this.collectionItemsRepository,
  });

  // TODO maybe Stream would be better here?
  Future<Iterable<BarcodeScanResult>> getResults(String barcode) async {
    final releasesMap = await getReleasesMap(barcode);

    // does user have already collection items of the release

    final releaseIds = releasesMap.keys.toSet();
    final collectionItems =
        await collectionItemsRepository.getByReleaseIds(releaseIds);
    final picsByRelease = await getPicsByReleaseMap(releaseIds);

    final List<BarcodeScanResult> results = <BarcodeScanResult>[];

    final releaseResults = releasesMap.values.map(
      (e) => BarcodeScanResult(
        description: e.name,
        releaseId: e.id!,
        type: BarcodeScanResultType.release,
        picFilename: picsByRelease[e.id]
                    ?.any((e) => e.pictureType == PictureType.coverFront) ??
                false
            ? picsByRelease[e.id]!
                .firstWhere((e) => e.pictureType == PictureType.coverFront)
                .filename
            : null,
      ),
    );

    results.addAll(releaseResults);

    final collectionItemResults = collectionItems.map(
      (e) => BarcodeScanResult(
        type: BarcodeScanResultType.collectionItem,
        description: releasesMap[e.releaseId]!.name,
        releaseId: e.releaseId!,
        collectionItemId: e.id,
        picFilename: picsByRelease[e.releaseId]
                    ?.any((e) => e.pictureType == PictureType.coverFront) ??
                false
            ? picsByRelease[e.releaseId]!
                .firstWhere((e) => e.pictureType == PictureType.coverFront)
                .filename
            : null,
      ),
    );

    results.addAll(collectionItemResults);

    return results;
  }

  Future<bool> barcodeExists(String barcode) async {
    return releaseRepository.barcodeExists(barcode);
  }

  Future<Map<int, Release>> getReleasesMap(String barcode) async {
    final releases =
        await releaseRepository.query(ReleaseQuerySpecs(barcode: barcode));
    final releasesMap = <int, Release>{};
    for (final release in releases) {
      releasesMap[release.id!] = release;
    }
    return releasesMap;
  }

  Future<Map<int, List<ReleasePicture>>> getPicsByReleaseMap(
      Iterable<int> releaseIds) async {
    final pics = await releasePicturesRepository
        .getByReleaseIds(releaseIds); // , [PictureType.coverFront]
    final picsByReleaseMap = <int, List<ReleasePicture>>{};
    for (final pic in pics) {
      if (picsByReleaseMap[pic.releaseId] == null) {
        picsByReleaseMap[pic.releaseId!] = <ReleasePicture>[];
      }
      picsByReleaseMap[pic.releaseId!]!.add(pic);
    }
    return picsByReleaseMap;
  }

  Future<Map<int, Set<MediaType>>> getMediaTypesByReleaseMap(
      Iterable<int> releaseIds) async {
    final releaseMedias =
        await releaseMediasRepository.getByReleaseIds(releaseIds);
    final mediaTypesByRelease = <int, Set<MediaType>>{};
    for (final releaseMedia in releaseMedias) {
      if (mediaTypesByRelease[releaseMedia.releaseId] == null) {
        mediaTypesByRelease[releaseMedia.releaseId!] = <MediaType>{};
      }
      mediaTypesByRelease[releaseMedia.releaseId!]!.add(releaseMedia.mediaType);
    }
    return mediaTypesByRelease;
  }

  Future<Map<int, List<Production>>> getProductionsByReleaseMap(
      Iterable<int> releaseIds) async {
    final releaseProductions =
        await releaseProductionsRepository.getByReleaseIds(releaseIds);
    final productionIds = releaseProductions.map((e) => e.productionId).toSet();
    final productions = await productionsRepository.getByIds(productionIds);

    final productionsByRelease = <int, List<Production>>{};

    for (final releaseProduction in releaseProductions) {
      if (productionsByRelease[releaseProduction.releaseId] == null) {
        productionsByRelease[releaseProduction.releaseId!] = <Production>[];
      }
      final production = productions
          .where((element) => element.id == releaseProduction.id)
          .first;
      productionsByRelease[releaseProduction.releaseId]!.add(production);
    }
    return productionsByRelease;
  }
}
