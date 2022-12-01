import 'package:film_freak/models/list_models/collection_item_list_model.dart';
import 'package:flutter/material.dart';

import '../../models/collection_item_query_specs.dart';
import '../../services/collection_item_service.dart';
import '../../widgets/collection_item_list.dart';
import '../../widgets/error_display_widget.dart';
import '../../widgets/spinner.dart';

class CollectionItemFilterList extends StatefulWidget {
  const CollectionItemFilterList({
    super.key,
    required this.service,
    required this.specs,
    required this.saveDir,
    required this.onDelete,
    required this.onEdit,
  });
  final CollectionItemService service;
  final CollectionItemQuerySpecs? specs;
  final String saveDir;
  final OnDeleteCallback onDelete;
  final OnEditCallback onEdit;

  @override
  State<CollectionItemFilterList> createState() =>
      _CollectionItemFilterListState();
}

class _CollectionItemFilterListState extends State<CollectionItemFilterList> {
  late Future<Iterable<CollectionItemListModel>> _futureListItems;

  @override
  void initState() {
    super.initState();
    _futureListItems = _getCollectionItems();
  }

  Future<Iterable<CollectionItemListModel>> _getCollectionItems() async {
    if (widget.specs == null) return [];
    return await widget.service.getListModels(widget.specs);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _futureListItems,
        builder: (BuildContext context,
            AsyncSnapshot<Iterable<CollectionItemListModel>> snapshot) {
          if (snapshot.hasError) {
            return ErrorDisplayWidget(snapshot.error.toString());
          }
          if (!snapshot.hasData) {
            return const Spinner();
          }
          return CollectionItemList(
            collectionItems: snapshot.data!.toList(),
            onDelete: widget.onDelete,
            onEdit: widget.onEdit,
            saveDir: widget.saveDir,
          );
        });
  }
}
