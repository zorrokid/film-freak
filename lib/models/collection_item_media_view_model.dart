import 'package:film_freak/entities/collection_item_media.dart';
import 'package:film_freak/entities/release_media.dart';

class CollectionItemMediaViewModel {
  final ReleaseMedia releaseMedia;
  final CollectionItemMedia collectionItemMedia;
  const CollectionItemMediaViewModel({
    required this.releaseMedia,
    required this.collectionItemMedia,
  });
}
