import 'package:film_freak/models/collection_item_list_model.dart';
import 'package:film_freak/widgets/release_list_tile.dart';
import 'package:flutter/material.dart';

typedef OnDeleteCallback = Future<void> Function(int id);
typedef OnEditCallback = Future<void> Function(int id);

class ReleaseList extends StatelessWidget {
  const ReleaseList({
    super.key,
    required this.releases,
    required this.onDelete,
    required this.onEdit,
    required this.saveDir,
  });

  final List<CollectionItemListModel> releases;
  final OnDeleteCallback onDelete;
  final OnEditCallback onEdit;
  final String saveDir;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: releases.length,
      itemBuilder: (context, index) {
        return ReleaseListTile(
          collectionItem: releases[index],
          onDelete: onDelete,
          onEdit: onEdit,
          saveDir: saveDir,
        );
      },
    );
  }
}
