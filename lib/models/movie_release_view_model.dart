import 'package:film_freak/entities/movie_release.dart';
import 'package:film_freak/entities/release_picture.dart';

class MovieReleaseViewModel {
  final MovieRelease release;
  final List<ReleasePicture> releasePictures;
  const MovieReleaseViewModel(
      {required this.release, required this.releasePictures});
}
