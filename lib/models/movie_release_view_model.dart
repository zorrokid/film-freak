import 'package:film_freak/entities/movie_release.dart';
import 'package:film_freak/entities/release_picture.dart';

import '../enums/release_property_type.dart';

class MovieReleaseViewModel {
  final MovieRelease release;
  final List<ReleasePicture> releasePictures;
  final List<ReleasePropertyType> releaseProperties;
  const MovieReleaseViewModel(
      {required this.release,
      required this.releasePictures,
      required this.releaseProperties});
}
