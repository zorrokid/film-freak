import '../domain/entities/collection_item_media.dart';
import '../domain/entities/release_media.dart';

class CollectionItemMediaViewModel {
  final ReleaseMedia releaseMedia;
  final CollectionItemMedia collectionItemMedia;
  const CollectionItemMediaViewModel({
    required this.releaseMedia,
    required this.collectionItemMedia,
  });
}
