import 'package:flutter/material.dart';
import '../models/list_models/release_list_model.dart';
import 'collection_item_list.dart';
import 'release_list_tile.dart';

typedef OnCreateCallback = Future<void> Function(int id);

class ReleaseFilterList extends StatelessWidget {
  const ReleaseFilterList({
    super.key,
    required this.saveDir,
    required this.onCreate,
    required this.onDelete,
    required this.onEdit,
    required this.releases,
  });
  final String saveDir;
  final OnCreateCallback onCreate;
  final OnEditCallback onEdit;
  final OnDeleteCallback onDelete;
  final List<ReleaseListModel> releases;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: releases.length,
      itemBuilder: (context, index) {
        return ReleaseListTile(
          item: releases[index],
          onCreate: onCreate,
          onDelete: onDelete,
          onEdit: onEdit,
          saveDir: saveDir,
        );
      },
    );
  }
}
