import 'package:film_freak/models/movie_release_view_model.dart';
import 'package:film_freak/utils/file_utils.dart';

import '../entities/movie_release.dart';
import '../persistence/db_provider.dart';
import '../persistence/repositories/release_pictures_repository.dart';
import '../persistence/repositories/release_properties_repository.dart';
import '../persistence/repositories/release_repository.dart';
import '../utils/directory_utils.dart';

class MovieReleaseService {
  final _releaseRepository = ReleaseRepository(DatabaseProvider.instance);
  final _releasePicturesRepository =
      ReleasePicturesRepository(DatabaseProvider.instance);
  final _releasePropertiesRepository =
      ReleasePropertiesRepository(DatabaseProvider.instance);

  Future<MovieReleaseViewModel> getReleaseData(int releaseId) async {
    final release = await _releaseRepository.getRelease(releaseId);
    final releasePictures =
        await _releasePicturesRepository.getByReleaseId(releaseId);
    final releaseProperties =
        await _releasePropertiesRepository.getByReleaseId(releaseId);
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
      await _releaseRepository.updateRelease(viewModel.release);
    } else {
      id = await _releaseRepository.insertRelease(viewModel.release);
    }
    await _releasePicturesRepository.upsert(id, viewModel.releasePictures);
    await _releasePropertiesRepository.upsert(id, viewModel.releaseProperties);

    return id;
  }

  Future<void> _deleteObsoletedPics(MovieReleaseViewModel model) async {
    final id = model.release.id!;
    final originalPicsInDb =
        await _releasePicturesRepository.getByReleaseId(id);
    final modifiedPicsIds = model.releasePictures.map((e) => e.id);
    final picIdsToBeDeleted =
        originalPicsInDb.where((e) => !modifiedPicsIds.contains(e.id));
    for (final pic in picIdsToBeDeleted) {
      await _releasePicturesRepository.delete(pic.id!);
    }
  }

  Future<void> _deleteObsoletedProperties(MovieReleaseViewModel model) async {
    final id = model.release.id!;
    final originalPropsInDb =
        await _releasePropertiesRepository.getByReleaseId(id);
    final modifiedPropTypes = model.releaseProperties;
    final propsToBeDeleted = originalPropsInDb
        .where((e) => !modifiedPropTypes.contains(e.propertyType));
    for (final picId in propsToBeDeleted) {
      await _releasePropertiesRepository.delete(picId.id!);
    }
  }

  // Future<void> upsertPicture(ReleasePicture picture) async {
  //   await _releasePicturesRepository.upsert(picture);
  // }

  Future<void> deletePicture(int pictureId) async {
    await _releasePicturesRepository.delete(pictureId);
  }

  Future<Iterable<MovieRelease>> getMovieReleases() async {
    final releases = await _releaseRepository.queryReleases();
    return releases;
  }

  Future<bool> deleteRelease(int releaseId) async {
    final pics = await _releasePicturesRepository.getByReleaseId(releaseId);

    final fileNames = pics.map((p) => p.filename);
    final filePath = await getReleasePicsSaveDir();
    final deletedFileCount = deleteFiles(fileNames, filePath.path);
    if (deletedFileCount < fileNames.length) {
      return false;
    }
    await _releasePicturesRepository.delete(releaseId);
    await _releasePropertiesRepository.delete(releaseId);
    await _releaseRepository.delete(releaseId);

    return true;
  }
}
