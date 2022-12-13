import 'package:film_freak/entities/release_picture.dart';
import 'package:film_freak/entities/release_property.dart';
import 'package:film_freak/models/list_models/release_list_model.dart';
import 'package:film_freak/persistence/repositories/releases_repository.dart';
import 'package:logging/logging.dart';

import '../entities/production.dart';
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
  final ReleasesRepository releaseRepository;
  final ReleasePicturesRepository releasePicturesRepository;
  final ReleasePropertiesRepository releasePropertiesRepository;
  final ProductionsRepository productions;

  ReleaseViewModel initializeModel(String? barcode) {
    final release = Release.empty();
    release.barcode = barcode ?? '';
    return ReleaseViewModel(release: release, pictures: [], properties: []);
  }

  Future<ReleaseViewModel> getReleaseData(int releaseId) async {
    final release = await releaseRepository.get(releaseId, Release.fromMap);
    final releasePictures = await releasePicturesRepository.getByReleaseId(
        releaseId, ReleasePicture.fromMap);
    final releaseProperties = await releasePropertiesRepository.getByReleaseId(
        releaseId, ReleaseProperty.fromMap);

    Production? movie;
    if (release.productionId != null) {
      movie = await productions.get(release.productionId!, Production.fromMap);
    }
    return ReleaseViewModel(
      release: release,
      pictures: releasePictures.toList(),
      properties: releaseProperties.toList(),
      production: movie,
    );
  }

  Future<int> upsert(ReleaseViewModel viewModel) async {
    int id;

    if (viewModel.production != null) {
      final movie = viewModel.production!;
      // check if movie entry with tmdb id already exists and assign id if it does
      if (movie.id == null && movie.tmdbId != null) {
        final existsingMovie = await productions.getByTmdbId(movie.tmdbId!);
        if (existsingMovie != null) {
          movie.id = existsingMovie.id;
        }
      }
      final movieId = await productions.upsert(viewModel.production!);
      viewModel.release.productionId = movieId;
    }

    if (viewModel.release.id != null) {
      id = viewModel.release.id!;
      await _deleteObsoletedPics(viewModel);
      await _deleteObsoletedProperties(viewModel);
      await releaseRepository.update(viewModel.release);
    } else {
      id = await releaseRepository.insert(viewModel.release);
    }
    await releasePicturesRepository.upsert(id, viewModel.pictures);
    await releasePropertiesRepository.upsert(id, viewModel.properties);

    return id;
  }

  Future<Iterable<ReleaseListModel>> getListModels(
      ReleaseQuerySpecs? filter) async {
    final releases = await releaseRepository.query(filter);
    final productionIds = releases
        .where((e) => e.productionId != null)
        .map((e) => e.productionId!)
        .toSet();
    final movies = await productions.getByIds(productionIds);
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
          productionNames: e.productionId != null
              ? movies.singleWhere((m) => m.id == e.productionId).title
              : null,
          picFileName: pics.any((p) => p.releaseId == e.id)
              ? pics.firstWhere((p) => p.releaseId == e.id).filename
              : null,
        ));

    return collectionItems;
  }

  Future<void> _deleteObsoletedPics(ReleaseViewModel model) async {
    final id = model.release.id!;
    final originalPicsInDb = await releasePicturesRepository.getByReleaseId(
        id, ReleasePicture.fromMap);
    final modifiedPicsIds = model.pictures.map((e) => e.id);
    final picIdsToBeDeleted =
        originalPicsInDb.where((e) => !modifiedPicsIds.contains(e.id));
    for (final pic in picIdsToBeDeleted) {
      await releasePicturesRepository.delete(pic.id!);
    }
  }

  Future<void> _deleteObsoletedProperties(ReleaseViewModel model) async {
    final id = model.release.id!;
    final originalPropsInDb = await releasePropertiesRepository.getByReleaseId(
        id, ReleaseProperty.fromMap);
    final modifiedPropTypes = model.properties.map((e) => e.propertyType);
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
