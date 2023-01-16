import 'package:film_freak/domain/entities/collection_item.dart';
import 'package:film_freak/domain/entities/release.dart';
import 'package:film_freak/domain/entities/release_comment.dart';
import 'package:film_freak/domain/entities/release_media.dart';
import 'package:film_freak/domain/entities/release_picture.dart';

import '../domain/entities/production.dart';
import '../domain/entities/release_property.dart';

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
