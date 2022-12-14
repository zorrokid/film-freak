import 'package:film_freak/models/list_models/release_list_model.dart';
import 'package:film_freak/persistence/repositories/release_comments_repository.dart';
import 'package:film_freak/persistence/repositories/release_medias_repository.dart';
import 'package:film_freak/persistence/repositories/release_productions_repository.dart';
import 'package:film_freak/persistence/repositories/releases_repository.dart';
import 'package:logging/logging.dart';

import '../entities/release.dart';
import '../enums/media_type.dart';
import '../enums/picture_type.dart';
import '../models/release_view_model.dart';
import '../persistence/db_provider.dart';
import '../persistence/query_specs/release_query_specs.dart';
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

  Future<ReleaseViewModel> getReleaseData(int releaseId) async {
    final release = await releaseRepository.get(releaseId, Release.fromMap);
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

    // TODO: add productions, medias, comments
    // if (viewModel.production != null) {
    //   final movie = viewModel.production!;
    //   // check if movie entry with tmdb id already exists and assign id if it does
    //   if (movie.id == null && movie.tmdbId != null) {
    //     final existsingMovie = await productions.getByTmdbId(movie.tmdbId!);
    //     if (existsingMovie != null) {
    //       movie.id = existsingMovie.id;
    //     }
    //   }
    //   final movieId = await productions.upsert(viewModel.production!);
    //   viewModel.release.productionId = movieId;
    // }

    if (viewModel.release.id != null) {
      id = viewModel.release.id!;
      await releaseRepository.update(viewModel.release);
    } else {
      id = await releaseRepository.insert(viewModel.release);
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
    // TODO
    // final productionIds = releases
    //     .where((e) => e.productionId != null)
    //     .map((e) => e.productionId!)
    //     .toSet();
    // final movies = await productions.getByIds(productionIds);
    final releaseIds = releases.map((e) => e.id!).toSet();
    final pics = await releasePicturesRepository
        .getByReleaseIds(releaseIds, [PictureType.coverFront]);

    final List<MediaType> mediaTypes = <MediaType>[];

    final collectionItems = releases.map((e) => ReleaseListModel(
          barcode: e.barcode,
          caseType: e.caseType,
          id: e.id!,
          mediaTypes: mediaTypes,
          name: e.name,
          // TODO
          productionNames: [] /*e.productionId != null
              ? movies.singleWhere((m) => m.id == e.productionId).title
              : null*/
          ,
          picFileName: pics.any((p) => p.releaseId == e.id)
              ? pics.firstWhere((p) => p.releaseId == e.id).filename
              : null,
        ));

    return collectionItems;
  }

  Future<bool> barcodeExists(String barcode) async {
    return releaseRepository.barcodeExists(barcode);
  }
}
