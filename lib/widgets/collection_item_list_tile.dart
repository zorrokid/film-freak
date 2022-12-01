import 'dart:io';

import 'package:film_freak/features/view_release/release_screen.dart';
import 'package:film_freak/models/list_models/collection_item_list_model.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../enums/media_type.dart';
import 'condition_icon.dart';

typedef OnDeleteCallback = void Function(int id);
typedef OnEditCallback = void Function(int id);

class CollectionItemListTile extends StatelessWidget {
  const CollectionItemListTile({
    required this.collectionItem,
    required this.onDelete,
    required this.onEdit,
    required this.saveDir,
    super.key,
  });
  final CollectionItemListModel collectionItem;
  final OnDeleteCallback onDelete;
  final OnEditCallback onEdit;
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
          Expanded(
              child: Text(
                  mediaTypeFormFieldValues[collectionItem.mediaType] ?? "")),
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
      onTap: () => {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return ReleaseScreen(id: collectionItem.id!);
          },
        ))
      },
    );
  }
}
