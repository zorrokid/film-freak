import 'package:film_freak/entities/movie_release.dart';
import 'package:film_freak/widgets/release_list_tile.dart';
import 'package:flutter/material.dart';

typedef OnDeleteCallback = Future<void> Function(int id);
typedef OnEditCallback = Future<void> Function(int id);

class ReleaseList extends StatelessWidget {
  const ReleaseList(
      {super.key,
      required this.releases,
      required this.onDelete,
      required this.onEdit});

  final List<MovieRelease> releases;
  final OnDeleteCallback onDelete;
  final OnEditCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: releases.length,
      itemBuilder: (context, index) {
        return ReleaseListTile(
          release: releases[index],
          onDelete: onDelete,
          onEdit: onEdit,
        );
      },
    );
  }
}
