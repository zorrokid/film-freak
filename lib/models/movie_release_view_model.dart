import 'package:film_freak/models/movie_release.dart';
import 'package:film_freak/models/release_picture.dart';

class MovieReleaseViewModel {
  final MovieRelease release;
  final List<ReleasePicture> releasePictures;
  const MovieReleaseViewModel(
      {required this.release, required this.releasePictures});
}
