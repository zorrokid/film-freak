import 'package:film_freak/models/movie_release_view_model.dart';

import '../models/movie_release.dart';
import '../persistence/db_provider.dart';
import '../persistence/release_pictures_repository.dart';
import '../persistence/release_repository.dart';

class MovieReleaseService {
  final _releaseRepository =
      ReleaseRepository(databaseProvider: DatabaseProvider.instance);
  final _releasePicturesRepository =
      ReleasePicturesRepository(databaseProvider: DatabaseProvider.instance);

  Future<MovieReleaseViewModel> getReleaseData(int releaseId) async {
    final release = await _releaseRepository.getRelease(releaseId);
    final releasePictures =
        await _releasePicturesRepository.getByRelease(releaseId);
    return MovieReleaseViewModel(
        release: release, releasePictures: releasePictures.toList());
  }

  MovieReleaseViewModel initializeModel(String? barcode) {
    final release = MovieRelease.init();
    release.barcode = barcode ?? '';
    return MovieReleaseViewModel(release: release, releasePictures: []);
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
    final originalPicsInDb = await _releasePicturesRepository.getByRelease(id);
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
}
