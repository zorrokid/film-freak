import 'package:film_freak/entities/release_production.dart';
import 'package:logging/logging.dart';

import '../entities/release_picture.dart';
import '../entities/production.dart';
import '../entities/release.dart';
import '../enums/media_type.dart';
import '../enums/picture_type.dart';
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
  final dbProvider = DatabaseProvider.instance;
  return ReleaseService(
    releaseRepository: ReleasesRepository(dbProvider),
    releasePicturesRepository: ReleasePicturesRepository(dbProvider),
    releasePropertiesRepository: ReleasePropertiesRepository(dbProvider),
    productionsRepository: ProductionsRepository(dbProvider),
    releaseMediasRepository: ReleaseMediasRepository(dbProvider),
    releaseProductionsRepository: ReleaseProductionsRepository(dbProvider),
    releaseCommentsRepository: ReleaseCommentsRepository(dbProvider),
  );
}

class ReleaseService {
  ReleaseService({
    required this.releaseRepository,
    required this.releasePicturesRepository,
    required this.releasePropertiesRepository,
    required this.productionsRepository,
    required this.releaseProductionsRepository,
    required this.releaseMediasRepository,
    required this.releaseCommentsRepository,
  });

  final log = Logger('ReleaseService');
  final ReleasesRepository releaseRepository;
  final ReleasePicturesRepository releasePicturesRepository;
  final ReleasePropertiesRepository releasePropertiesRepository;
  final ProductionsRepository productionsRepository;
  final ReleaseProductionsRepository releaseProductionsRepository;
  final ReleaseMediasRepository releaseMediasRepository;
  final ReleaseCommentsRepository releaseCommentsRepository;

  ReleaseViewModel initializeModel(String? barcode) {
    final release = Release.empty();
    release.barcode = barcode ?? '';
    return ReleaseViewModel(
        release: release,
        pictures: [],
        properties: [],
        productions: [],
        comments: [],
        medias: []);
  }

  Future<ReleaseViewModel> getModel(int releaseId) async {
    final release = await releaseRepository.get(releaseId);
    final releasePictures =
        await releasePicturesRepository.getByReleaseId(releaseId);
    final releaseProperties =
        await releasePropertiesRepository.getByReleaseId(releaseId);
    final releaseProductions =
        await releaseProductionsRepository.getByReleaseId(releaseId);
    final productions = await productionsRepository
        .getByIds(releaseProductions.map((e) => e.productionId));
    final medias = await releaseMediasRepository.getByReleaseId(releaseId);
    final comments = await releaseCommentsRepository.getByReleaseId(releaseId);

    return ReleaseViewModel(
      release: release,
      pictures: releasePictures,
      properties: releaseProperties,
      productions: productions,
      comments: comments,
      medias: medias,
    );
  }

  Future<int> upsert(ReleaseViewModel viewModel) async {
    int id;

    if (viewModel.release.id != null) {
      id = viewModel.release.id!;
      await releaseRepository.update(viewModel.release);
    } else {
      id = await releaseRepository.insert(viewModel.release);
    }

    if (viewModel.productions.isNotEmpty) {
      for (final production in viewModel.productions) {
        // check if movie entry with tmdb id already exists and assign id if it does
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

      await releaseProductionsRepository.upsert(
          id,
          viewModel.productions.map(
              (e) => ReleaseProduction(releaseId: id, productionId: e.id!)));
    }

    await releasePicturesRepository.upsert(id, viewModel.pictures);
    await releasePropertiesRepository.upsert(id, viewModel.properties);
    await releaseCommentsRepository.upsert(id, viewModel.comments);
    await releaseMediasRepository.upsert(id, viewModel.medias);

    return id;
  }

  Future<Iterable<ReleaseListModel>> getListModels(
      ReleaseQuerySpecs? filter) async {
    final releases = await releaseRepository.query(filter);
    final releaseIds = releases.map((e) => e.id!).toSet();

    final productionsByRelease = await getProductionsByReleaseMap(releaseIds);
    final mediaTypesByRelease = await getMediaTypesByReleaseMap(releaseIds);
    final picsByRelease = await getPicsByReleaseMap(releaseIds);

    final collectionItems = releases.map(
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

    return collectionItems;
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
