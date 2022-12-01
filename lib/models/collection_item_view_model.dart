import 'package:film_freak/entities/movie_release.dart';
import 'package:film_freak/entities/release_picture.dart';

import '../entities/collection_item.dart';
import '../entities/movie.dart';
import '../entities/release_property.dart';

class CollectionItemViewModel {
  final CollectionItem collectionItem;
  final MovieRelease release;
  final List<ReleasePicture> releasePictures;
  final List<ReleaseProperty> releaseProperties;
  final Movie? movie;
  const CollectionItemViewModel({
    required this.collectionItem,
    required this.release,
    required this.releasePictures,
    required this.releaseProperties,
    this.movie,
  });
}
