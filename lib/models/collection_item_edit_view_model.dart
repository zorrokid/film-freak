import 'collection_item_media_view_model.dart';
import '../domain/entities/collection_item.dart';
import '../domain/entities/collection_item_property.dart';

class CollectionItemEditViewModel {
  final CollectionItem collectionItem;
  final List<CollectionItemProperty> properties;
  final List<CollectionItemMediaViewModel> media;
  CollectionItemEditViewModel({
    required this.collectionItem,
    required this.properties,
    required this.media,
  });
}
