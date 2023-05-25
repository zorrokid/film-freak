import 'package:logging/logging.dart';
import '../persistence/repositories/collection_items_repository.dart';
import '../services/production_service.dart';
import '../domain/entities/release_picture.dart';
import '../domain/entities/production.dart';
import '../domain/entities/release.dart';
import '../domain/enums/media_type.dart';
import '../domain/enums/picture_type.dart';
import '../models/list_models/release_list_model.dart';
import '../models/release_view_model.dart';
import '../persistence/db_provider.dart';
import '../persistence/query_specs/release_query_specs.dart';
import '../persistence/repositories/release_comments_repository.dart';
import '../persistence/repositories/release_medias_repository.dart';
import '../persistence/repositories/release_productions_repository.dart';
import '../persistence/repositories/releases_repository.dart';
import '../persistence/repositories/productions_repository.dart';
import '../persistence/repositories/release_pictures_repository.dart';
import '../persistence/repositories/release_properties_repository.dart';

ReleaseService initializeReleaseService() {
  final dbProvider = DatabaseProviderSqflite.instance;
  return ReleaseService(
    releaseRepository: ReleasesRepository(dbProvider),
    releasePicturesRepository: ReleasePicturesRepository(dbProvider),
    releasePropertiesRepository: ReleasePropertiesRepository(dbProvider),
    productionService: ProductionService(
      productionsRepository: ProductionsRepository(dbProvider),
      releaseProductionsRepository: ReleaseProductionsRepository(dbProvider),
    ),
    releaseMediasRepository: ReleaseMediasRepository(dbProvider),
    releaseCommentsRepository: ReleaseCommentsRepository(dbProvider),
    collectionItemsRepository: CollectionItemsRepository(dbProvider),
  );
}

class ReleaseService {
  ReleaseService({
    required this.releaseRepository,
    required this.releasePicturesRepository,
    required this.releasePropertiesRepository,
    required this.productionService,
    required this.releaseMediasRepository,
    required this.releaseCommentsRepository,
    required this.collectionItemsRepository,
  });

  final log = Logger('ReleaseService');
  final ReleasesRepository releaseRepository;
  final ReleasePicturesRepository releasePicturesRepository;
  final ReleasePropertiesRepository releasePropertiesRepository;
  final ProductionService productionService;
  final ReleaseMediasRepository releaseMediasRepository;
  final ReleaseCommentsRepository releaseCommentsRepository;
  final CollectionItemsRepository collectionItemsRepository;

  ReleaseViewModel initializeModel(String? barcode) {
    final release = Release.empty();
    release.barcode = barcode ?? '';
    return ReleaseViewModel(
      release: release,
      pictures: [],
      properties: [],
      productions: [],
      comments: [],
      medias: [],
      collectionItems: [],
    );
  }

  Future<ReleaseViewModel> getModel(int releaseId) async {
    final release = await releaseRepository.get(releaseId);
    final releasePictures =
        await releasePicturesRepository.getByReleaseId(releaseId);
    final releaseProperties =
        await releasePropertiesRepository.getByReleaseId(releaseId);
    final releaseProductions =
        await productionService.getReleaseProductions(releaseId);
    final productions = await productionService
        .getProductionsByIds(releaseProductions.map((e) => e.productionId));
    final medias = await releaseMediasRepository.getByReleaseId(releaseId);
    final comments = await releaseCommentsRepository.getByReleaseId(releaseId);
    final collectionItems =
        await collectionItemsRepository.getByReleaseId(releaseId);

    return ReleaseViewModel(
      release: release,
      pictures: releasePictures,
      properties: releaseProperties,
      productions: productions,
      comments: comments,
      medias: medias,
      collectionItems: collectionItems,
    );
  }

  Future<int> upsert(ReleaseViewModel viewModel) async {
    int releaseId = await _upsertRelease(viewModel.release);
    await productionService.upsertProductions(viewModel.productions);
    await productionService.updateProductionLinks(
        releaseId, viewModel.productions);
    await releasePicturesRepository.upsertChildren(
        releaseId, viewModel.pictures);
    await releasePropertiesRepository.upsertChildren(
        releaseId, viewModel.properties);
    await releaseCommentsRepository.upsertChildren(
        releaseId, viewModel.comments);
    await releaseMediasRepository.upsertChildren(releaseId, viewModel.medias);
    return releaseId;
  }

  Future<bool> barcodeExists(String barcode) async {
    return releaseRepository.barcodeExists(barcode);
  }

  Future<int> delete(int id) async {
    return await releaseRepository.delete(id);
  }

  Future<int> _upsertRelease(Release release) async {
    int releaseId;
    if (release.id != null) {
      releaseId = release.id!;
      await releaseRepository.update(release);
    } else {
      releaseId = await releaseRepository.insert(release);
    }

    return releaseId;
  }

  Future<Iterable<ReleaseListModel>> getListModels({
    ReleaseQuerySpecs? filter,
  }) async {
    final releases = filter != null
        ? await releaseRepository.query(filter)
        : await releaseRepository.getAll();
    final releaseIds = releases.map((e) => e.id!).toSet();

    final productionsByRelease = await getProductionsByReleaseMap(releaseIds);
    final mediaTypesByRelease = await getMediaTypesByReleaseMap(releaseIds);
    final picsByRelease = await getPicsByReleaseMap(releaseIds);

    final listModels = releases.map(
      (e) => ReleaseListModel(
        barcode: e.barcode,
        caseType: e.caseType,
        id: e.id!,
        mediaTypes: mediaTypesByRelease[e.id]?.toList() ?? [],
        name: e.name,
        productionNames:
            productionsByRelease[e.id]?.map((e) => e.title).toList() ?? [],
        picFileName: picsByRelease[e.id]
                    ?.any((e) => e.pictureType == PictureType.coverFront) ??
                false
            ? picsByRelease[e.id]!
                .firstWhere((e) => e.pictureType == PictureType.coverFront)
                .filename
            : null,
      ),
    );

    return listModels;
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
        await productionService.getReleaseProductionsByReleaseIds(releaseIds);
    final productionIds = releaseProductions.map((e) => e.productionId).toSet();
    final productions =
        await productionService.getProductionsByIds(productionIds);

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
