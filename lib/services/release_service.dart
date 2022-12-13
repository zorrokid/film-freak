import 'package:film_freak/models/list_models/release_list_model.dart';
import 'package:film_freak/persistence/repositories/release_repository.dart';
import 'package:logging/logging.dart';

import '../entities/production.dart';
import '../entities/release.dart';
import '../enums/media_type.dart';
import '../enums/picture_type.dart';
import '../models/collection_item_query_specs.dart';
import '../models/movie_release_view_model.dart';
import '../persistence/db_provider.dart';
import '../persistence/repositories/productions_repository.dart';
import '../persistence/repositories/release_pictures_repository.dart';
import '../persistence/repositories/release_properties_repository.dart';

ReleaseService initializeReleaseService() {
  final dbProvider = DatabaseProvider.instance;
  return ReleaseService(
    releaseRepository: ReleaseRepository(dbProvider),
    releasePicturesRepository: ReleasePicturesRepository(dbProvider),
    releasePropertiesRepository: ReleasePropertiesRepository(dbProvider),
    productions: ProductionsRepository(dbProvider),
  );
}

class ReleaseService {
  ReleaseService({
    required this.releaseRepository,
    required this.releasePicturesRepository,
    required this.releasePropertiesRepository,
    required this.productions,
  });

  final log = Logger('ReleaseService');
  final ReleaseRepository releaseRepository;
  final ReleasePicturesRepository releasePicturesRepository;
  final ReleasePropertiesRepository releasePropertiesRepository;
  final ProductionsRepository productions;

  MovieReleaseViewModel initializeModel(String? barcode) {
    final release = Release.empty();
    release.barcode = barcode ?? '';
    return MovieReleaseViewModel(
        release: release, releasePictures: [], releaseProperties: []);
  }

  Future<MovieReleaseViewModel> getReleaseData(int releaseId) async {
    final release = await releaseRepository.get(releaseId, Release.fromMap);
    final releasePictures =
        await releasePicturesRepository.getByReleaseId(releaseId);
    final releaseProperties =
        await releasePropertiesRepository.getByReleaseId(releaseId);

    Production? movie;
    if (release.movieId != null) {
      movie = await productions.get(release.movieId!, Production.fromMap);
    }
    return MovieReleaseViewModel(
      release: release,
      releasePictures: releasePictures.toList(),
      releaseProperties: releaseProperties.toList(),
      movie: movie,
    );
  }

  Future<int> upsert(MovieReleaseViewModel viewModel) async {
    int id;

    if (viewModel.movie != null) {
      final movie = viewModel.movie!;
      // check if movie entry with tmdb id already exists and assign id if it does
      if (movie.id == null && movie.tmdbId != null) {
        final existsingMovie = await productions.getByTmdbId(movie.tmdbId!);
        if (existsingMovie != null) {
          movie.id = existsingMovie.id;
        }
      }
      final movieId = await productions.upsert(viewModel.movie!);
      viewModel.release.movieId = movieId;
    }

    if (viewModel.release.id != null) {
      id = viewModel.release.id!;
      await _deleteObsoletedPics(viewModel);
      await _deleteObsoletedProperties(viewModel);
      await releaseRepository.update(viewModel.release);
    } else {
      id = await releaseRepository.insert(viewModel.release);
    }
    await releasePicturesRepository.upsert(id, viewModel.releasePictures);
    await releasePropertiesRepository.upsert(id, viewModel.releaseProperties);

    return id;
  }

  Future<Iterable<ReleaseListModel>> getListModels(
      CollectionItemQuerySpecs? filter) async {
    final releases = await releaseRepository.query(filter);
    final movieIds =
        releases.where((e) => e.movieId != null).map((e) => e.movieId!).toSet();
    final movies = await productions.getByIds(movieIds);
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
          movieName: e.movieId != null
              ? movies.singleWhere((m) => m.id == e.movieId).title
              : null,
          picFileName: pics.any((p) => p.releaseId == e.id)
              ? pics.firstWhere((p) => p.releaseId == e.id).filename
              : null,
        ));

    return collectionItems;
  }

  Future<void> _deleteObsoletedPics(MovieReleaseViewModel model) async {
    final id = model.release.id!;
    final originalPicsInDb = await releasePicturesRepository.getByReleaseId(id);
    final modifiedPicsIds = model.releasePictures.map((e) => e.id);
    final picIdsToBeDeleted =
        originalPicsInDb.where((e) => !modifiedPicsIds.contains(e.id));
    for (final pic in picIdsToBeDeleted) {
      await releasePicturesRepository.delete(pic.id!);
    }
  }

  Future<void> _deleteObsoletedProperties(MovieReleaseViewModel model) async {
    final id = model.release.id!;
    final originalPropsInDb =
        await releasePropertiesRepository.getByReleaseId(id);
    final modifiedPropTypes =
        model.releaseProperties.map((e) => e.propertyType);
    final propsToBeDeleted = originalPropsInDb
        .where((e) => !modifiedPropTypes.contains(e.propertyType));
    for (final propId in propsToBeDeleted) {
      await releasePropertiesRepository.delete(propId.id!);
    }
  }

  Future<bool> barcodeExists(String barcode) async {
    return releaseRepository.barcodeExists(barcode);
  }
}
