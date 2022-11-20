import 'package:film_freak/entities/movie_release.dart';
import 'package:film_freak/screens/release_view.dart';
import 'package:flutter/material.dart';

import '../enums/media_type.dart';
import 'condition_icon.dart';

typedef OnDeleteCallback = void Function(int id);
typedef OnEditCallback = void Function(int id);

class ReleaseListTile extends StatelessWidget {
  const ReleaseListTile(
      {required this.release,
      required this.onDelete,
      required this.onEdit,
      super.key});
  final MovieRelease release;
  final OnDeleteCallback onDelete;
  final OnEditCallback onEdit;

  void menuItemSelected(String? value) {
    switch (value) {
      case 'delete':
        onDelete(release.id!);
        break;
      case 'edit':
        onEdit(release.id!);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(release.name.isNotEmpty ? release.name : release.barcode),
      subtitle: Row(
        children: [
          Expanded(
              child: Text(mediaTypeFormFieldValues[release.mediaType] ?? "")),
          ConditionIcon(condition: release.condition),
        ],
      ),
      leading: const Icon(Icons.image),
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
            return ReleaseView(releaseId: release.id!);
          },
        ))
      },
    );
  }
}
