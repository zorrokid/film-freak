import 'package:film_freak/entities/release.dart';
import 'package:film_freak/entities/release_picture.dart';

import '../entities/production.dart';
import '../entities/release_property.dart';

class MovieReleaseViewModel {
  final Release release;
  final List<ReleasePicture> releasePictures;
  final List<ReleaseProperty> releaseProperties;
  final Production? movie;
  const MovieReleaseViewModel(
      {required this.release,
      required this.releasePictures,
      required this.releaseProperties,
      this.movie});
}
