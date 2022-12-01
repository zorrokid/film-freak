import 'dart:io';

import 'package:film_freak/features/view_release/release_screen.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../enums/media_type.dart';
import '../models/list_models/release_list_model.dart';

typedef OnCreateCallback = void Function(int id);

class ReleaseListTile extends StatelessWidget {
  const ReleaseListTile({
    required this.item,
    required this.onCreate,
    required this.saveDir,
    super.key,
  });
  final ReleaseListModel item;
  final OnCreateCallback onCreate;
  final String saveDir;

  void menuItemSelected(String? value) {
    switch (value) {
      case 'create':
        onCreate(item.id);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.name.isNotEmpty ? item.name : item.barcode),
      subtitle: Row(
        children: [
          Expanded(child: Text(mediaTypeFormFieldValues[item.mediaType] ?? "")),
          // TODO MediaTypeIcon ? ,
        ],
      ),
      leading: item.picFileName != null
          ? Image.file(
              File(join(saveDir, item.picFileName)),
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
          ];
        },
        onSelected: menuItemSelected,
      ),
      onTap: () => {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return ReleaseScreen(id: item.id!);
          },
        ))
      },
    );
  }
}
