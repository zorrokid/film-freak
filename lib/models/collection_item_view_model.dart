import '../entities/collection_item.dart';
import '../entities/collection_item_comment.dart';
import '../entities/collection_item_property.dart';
import 'release_view_model.dart';

class CollectionItemViewModel {
  final CollectionItem collectionItem;
  final ReleaseViewModel releaseModel;
  final List<CollectionItemComment> comments;
  final List<CollectionItemProperty> properties;
  const CollectionItemViewModel({
    required this.collectionItem,
    required this.releaseModel,
    required this.comments,
    required this.properties,
  });
}
