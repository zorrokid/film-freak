import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import '../models/list_models/collection_item_list_model.dart';
import 'condition_icon.dart';

typedef OnDeleteCallback = void Function(int id);
typedef OnEditCallback = void Function(int id);
typedef OnTapCallback = void Function(int id);

class CollectionItemListTile extends StatelessWidget {
  const CollectionItemListTile({
    required this.collectionItem,
    required this.onDelete,
    required this.onEdit,
    required this.saveDir,
    required this.onTap,
    super.key,
  });
  final CollectionItemListModel collectionItem;
  final OnDeleteCallback onDelete;
  final OnEditCallback onEdit;
  final OnTapCallback onTap;
  final String saveDir;

  void menuItemSelected(String? value) {
    switch (value) {
      case 'delete':
        onDelete(collectionItem.id);
        break;
      case 'edit':
        onEdit(collectionItem.id);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(collectionItem.name.isNotEmpty
          ? collectionItem.name
          : collectionItem.barcode),
      subtitle: Row(
        children: [
          // TODO: show media types
          // Expanded(
          //     child: Text(
          //         mediaTypeFormFieldValues[collectionItem.mediaType] ?? "")),
          ConditionIcon(condition: collectionItem.condition),
        ],
      ),
      leading: collectionItem.picFileName != null
          ? Image.file(
              File(join(saveDir, collectionItem.picFileName)),
              height: 50,
            )
          : const Icon(Icons.image),
      trailing: PopupMenuButton(
        itemBuilder: (context) {
          return [
            const PopupMenuItem(
              value: 'delete',
              child: Text('Delete'),
            ),
            const PopupMenuItem(
              value: 'edit',
              child: Text('Edit'),
            ),
          ];
        },
        onSelected: menuItemSelected,
      ),
      onTap: () => onTap(collectionItem.id),
    );
  }
}
