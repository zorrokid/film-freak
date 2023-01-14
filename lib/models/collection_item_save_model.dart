import '../entities/collection_item.dart';
import '../entities/collection_item_media.dart';
import '../entities/collection_item_property.dart';

class CollectionItemSaveModel {
  final CollectionItem collectionItem;
  final List<CollectionItemProperty> properties;
  final List<CollectionItemMedia> media;
  CollectionItemSaveModel({
    required this.collectionItem,
    required this.properties,
    required this.media,
  });
}
