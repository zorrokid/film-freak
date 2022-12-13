import '../entities/collection_item.dart';
import '../entities/collection_item_comment.dart';
import '../entities/collection_item_property.dart';
import 'release_view_model.dart';

class CollectionItemViewModel {
  final CollectionItem collectionItem;
  final ReleaseViewModel release;
  final List<CollectionItemComment> comments;
  final List<CollectionItemProperty> properties;
  const CollectionItemViewModel({
    required this.collectionItem,
    required this.release,
    required this.comments,
    required this.properties,
  });
}
