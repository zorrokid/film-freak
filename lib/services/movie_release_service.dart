import 'package:film_freak/models/movie_release_view_model.dart';
import 'package:film_freak/models/movie_releases_list_filter.dart';
import 'package:film_freak/utils/file_utils.dart';
import 'package:logging/logging.dart';

import '../entities/movie_release.dart';
import '../persistence/db_provider.dart';
import '../persistence/repositories/release_pictures_repository.dart';
import '../persistence/repositories/release_properties_repository.dart';
import '../persistence/repositories/release_repository.dart';
import '../utils/directory_utils.dart';

MovieReleaseService initializeReleaseService() {
  final dbProvider = DatabaseProvider.instance;
  return MovieReleaseService(
      releaseRepository: ReleaseRepository(dbProvider),
      releasePicturesRepository: ReleasePicturesRepository(dbProvider),
      releasePropertiesRepository: ReleasePropertiesRepository(dbProvider));
}

class MovieReleaseService {
  MovieReleaseService(
      {required this.releaseRepository,
      required this.releasePicturesRepository,
      required this.releasePropertiesRepository});

  final log = Logger('MovieReleaseService');
  final ReleaseRepository releaseRepository;
  final ReleasePicturesRepository releasePicturesRepository;
  final ReleasePropertiesRepository releasePropertiesRepository;

  Future<MovieReleaseViewModel> getReleaseData(int releaseId) async {
    final release = await releaseRepository.getRelease(releaseId);
    final releasePictures =
        await releasePicturesRepository.getByReleaseId(releaseId);
    final releaseProperties =
        await releasePropertiesRepository.getByReleaseId(releaseId);
    return MovieReleaseViewModel(
        release: release,
        releasePictures: releasePictures.toList(),
        releaseProperties: releaseProperties.toList());
  }

  MovieReleaseViewModel initializeModel(String? barcode) {
    final release = MovieRelease.init();
    release.barcode = barcode ?? '';
    return MovieReleaseViewModel(
        release: release, releasePictures: [], releaseProperties: []);
  }

  Future<int> upsert(MovieReleaseViewModel viewModel) async {
    int id;
    if (viewModel.release.id != null) {
      id = viewModel.release.id!;
      await _deleteObsoletedPics(viewModel);
      await _deleteObsoletedProperties(viewModel);
      await releaseRepository.updateRelease(viewModel.release);
    } else {
      id = await releaseRepository.insertRelease(viewModel.release);
    }
    await releasePicturesRepository.upsert(id, viewModel.releasePictures);
    await releasePropertiesRepository.upsert(id, viewModel.releaseProperties);

    return id;
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

  Future<void> deletePicture(int pictureId) async {
    await releasePicturesRepository.delete(pictureId);
  }

  Future<Iterable<MovieRelease>> getMovieReleases(
      MovieReleasesListFilter? filter) async {
    final releases = await releaseRepository.queryReleases(filter);
    return releases;
  }

  Future<bool> deleteRelease(int releaseId) async {
    final pics = await releasePicturesRepository.getByReleaseId(releaseId);

    final fileNames = pics.map((p) => p.filename);
    final filePath = await getReleasePicsSaveDir();
    final deletedFileCount = deleteFiles(fileNames, filePath.path);
    if (deletedFileCount < fileNames.length) {
      log.warning('''Count of deleted files $deletedFileCount less than 
        count of files to be deleted ${fileNames.length}. 
        Skipping deleting from DB.''');
      return false;
    }
    final picRows =
        await releasePicturesRepository.deleteByReleaseId(releaseId);

    if (picRows < pics.length) {
      log.warning('''Count of deleted pic rows $picRows less than 
        count of pic rows to be deleted ${pics.length}. 
        Skipping deleting release from DB.''');
      return false;
    }
    await releasePropertiesRepository.deleteByReleaseId(releaseId);
    log.info('Deleting relase with id $releaseId.');
    await releaseRepository.delete(releaseId);

    return true;
  }
}
