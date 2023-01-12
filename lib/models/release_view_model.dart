import 'package:film_freak/entities/collection_item.dart';
import 'package:film_freak/entities/release.dart';
import 'package:film_freak/entities/release_comment.dart';
import 'package:film_freak/entities/release_media.dart';
import 'package:film_freak/entities/release_picture.dart';

import '../entities/production.dart';
import '../entities/release_property.dart';

class ReleaseViewModel {
  final Release release;
  final Iterable<ReleasePicture> pictures;
  final Iterable<ReleaseProperty> properties;
  final Iterable<Production> productions;
  final Iterable<ReleaseMedia> medias;
  final Iterable<ReleaseComment> comments;
  final Iterable<CollectionItem> collectionItems;
  const ReleaseViewModel({
    required this.release,
    required this.pictures,
    required this.properties,
    required this.productions,
    required this.medias,
    required this.comments,
    required this.collectionItems,
  });
}
