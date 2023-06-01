import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import '../models/list_models/release_list_model.dart';
import 'release_filter_list.dart';

typedef OnCreateCallback = void Function(int id);

class ReleaseListTile extends StatelessWidget {
  const ReleaseListTile({
    required this.item,
    required this.onCreate,
    required this.onDelete,
    required this.onEdit,
    required this.onTap,
    required this.saveDir,
    super.key,
  });
  final ReleaseListModel item;
  final OnCreateCallback onCreate;
  final OnEditCallback onEdit;
  final OnDeleteCallback onDelete;
  final OnTapCallback onTap;
  final Directory saveDir;

  void menuItemSelected(String? value) {
    switch (value) {
      case 'create':
        onCreate(item.id);
        break;
      case 'delete':
        onDelete(item.id);
        break;
      case 'edit':
        onEdit(item.id);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.name.isNotEmpty ? item.name : item.barcode),
      // TODO: show media types
      // subtitle: Row(
      //   children: [
      //     Expanded(child: Text(mediaTypeFormFieldValues[item.mediaType] ?? "")),
      //   ],
      // ),
      leading: item.picFileName != null
          ? Image.file(
              File(join(saveDir.path, item.picFileName)),
              height: 50,
            )
          : const Icon(Icons.image),
      trailing: PopupMenuButton(
        itemBuilder: (context) {
          return [
            const PopupMenuItem(
              value: 'create',
              child: Text('Create collection item'),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Text('Delete release'),
            ),
            const PopupMenuItem(
              value: 'edit',
              child: Text('Edit release'),
            ),
          ];
        },
        onSelected: menuItemSelected,
      ),
      onTap: () => onTap(item.id),
    );
  }
}
