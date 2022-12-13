import 'package:film_freak/entities/release.dart';
import 'package:film_freak/entities/release_comment.dart';
import 'package:film_freak/entities/release_media.dart';
import 'package:film_freak/entities/release_picture.dart';

import '../entities/production.dart';
import '../entities/release_property.dart';

class ReleaseViewModel {
  final Release release;
  final List<ReleasePicture> pictures;
  final List<ReleaseProperty> properties;
  final List<Production> productions;
  final List<ReleaseMedia> medias;
  final List<ReleaseComment> comments;
  const ReleaseViewModel({
    required this.release,
    required this.pictures,
    required this.properties,
    required this.productions,
    required this.medias,
    required this.comments,
  });
}
