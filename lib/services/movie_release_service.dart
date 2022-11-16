import 'package:film_freak/models/movie_release_view_model.dart';

import '../entities/movie_release.dart';
import '../persistence/db_provider.dart';
import '../persistence/repositories/release_pictures_repository.dart';
import '../persistence/repositories/release_properties_repository.dart';
import '../persistence/repositories/release_repository.dart';

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
        releaseProperties:
            releaseProperties.map((e) => e.propertyType).toList());
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
      await _releaseRepository.updateRelease(viewModel.release);
    } else {
      id = await _releaseRepository.insertRelease(viewModel.release);
    }
    await _releasePicturesRepository.upsert(viewModel.releasePictures);

    return id;
  }

  Future<void> _deleteObsoletedPics(MovieReleaseViewModel model) async {
    final id = model.release.id!;
    final originalPicsInDb =
        await _releasePicturesRepository.getByReleaseId(id);
    final originalPicIdsInDb = originalPicsInDb.map((e) => e.id).toList();
    final modifiedPicsIds = model.releasePictures.map((e) => e.id);
    final picIdsToBeDeleted =
        originalPicIdsInDb.where((e) => !modifiedPicsIds.contains(e));
    for (final picId in picIdsToBeDeleted) {
      await _releasePicturesRepository.delete(picId!);
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
}
