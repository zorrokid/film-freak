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
      await _releaseRepository.updateRelease(viewModel.release);
    } else {
      id = await _releaseRepository.insertRelease(viewModel.release);
    }
    await _releasePicturesRepository.upsert(viewModel.releasePictures);

    return id;
  }
}
