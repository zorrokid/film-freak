import 'package:flutter/material.dart';
import '../models/list_models/collection_item_list_model.dart';
import '../widgets/collection_item_list_tile.dart';

typedef OnDeleteCallback = Future<void> Function(int id);
typedef OnEditCallback = Future<void> Function(int id);

class CollectionItemList extends StatelessWidget {
  const CollectionItemList({
    super.key,
    required this.collectionItems,
    required this.onDelete,
    required this.onEdit,
    required this.saveDir,
  });

  final List<CollectionItemListModel> collectionItems;
  final OnDeleteCallback onDelete;
  final OnEditCallback onEdit;
  final String saveDir;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: collectionItems.length,
      itemBuilder: (context, index) {
        return CollectionItemListTile(
          collectionItem: collectionItems[index],
          onDelete: onDelete,
          onEdit: onEdit,
          saveDir: saveDir,
        );
      },
    );
  }
}
