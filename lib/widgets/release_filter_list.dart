import 'package:film_freak/services/release_service.dart';
import 'package:flutter/material.dart';

import '../models/collection_item_query_specs.dart';
import '../models/list_models/release_list_model.dart';
import 'error_display_widget.dart';
import 'release_list_tile.dart';
import 'spinner.dart';

typedef OnCreateCallback = Future<void> Function(int id);

class ReleaseFilterList extends StatefulWidget {
  const ReleaseFilterList({
    super.key,
    required this.service,
    required this.specs,
    required this.saveDir,
    required this.onCreate,
  });
  final ReleaseService service;
  final CollectionItemQuerySpecs? specs;
  final String saveDir;
  final OnCreateCallback onCreate;

  @override
  State<ReleaseFilterList> createState() => _ReleaseFilterListState();
}

class _ReleaseFilterListState extends State<ReleaseFilterList> {
  late Future<Iterable<ReleaseListModel>> _futureListItems;

  @override
  void initState() {
    super.initState();
    _futureListItems = _getReleases();
  }

  Future<Iterable<ReleaseListModel>> _getReleases() async {
    if (widget.specs == null) return [];
    return await widget.service.getListModels(widget.specs);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _futureListItems,
        builder: (BuildContext context,
            AsyncSnapshot<Iterable<ReleaseListModel>> snapshot) {
          if (snapshot.hasError) {
            return ErrorDisplayWidget(snapshot.error.toString());
          }
          if (!snapshot.hasData) {
            return const Spinner();
          }
          final data = snapshot.data!.toList();
          return ListView.builder(
            shrinkWrap: true,
            itemCount: data.length,
            itemBuilder: (context, index) {
              return ReleaseListTile(
                item: data[index],
                onCreate: widget.onCreate,
                saveDir: widget.saveDir,
              );
            },
          );
        });
  }
}
