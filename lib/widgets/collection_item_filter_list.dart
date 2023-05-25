import 'package:film_freak/services/release_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/list_models/collection_item_list_model.dart';
import '../persistence/query_specs/collection_item_query_specs.dart';
import '../screens/view_collection_item/collection_item_screen.dart';
import '../services/collection_item_service.dart';
import 'collection_item_list.dart';
import 'error_display_widget.dart';
import 'spinner.dart';

class CollectionItemFilterList extends StatefulWidget {
  const CollectionItemFilterList({
    super.key,
    required this.specs,
    required this.saveDir,
    required this.onDelete,
    required this.onEdit,
  });
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
    // TODO
    //return await widget.service.getListModels(widget.specs!);
    return [];
  }

  void reloadData() {
    setState(() {
      _futureListItems = _getCollectionItems();
    });
  }

  Future<void> onDelete(int id) async {
    await widget.onDelete(id);
    reloadData();
  }

  Future<void> onEdit(int id) async {
    await widget.onEdit(id);
    reloadData();
  }

  Future<void> viewCollectionItem(int id) async {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return CollectionItemScreen(
          id: id,
          collectionItemService: context.read<CollectionItemService>(),
          releaseService: context.read<ReleaseService>(),
        );
      },
    ));
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
          onDelete: onDelete,
          onEdit: widget.onEdit,
          onTap: viewCollectionItem,
          saveDir: widget.saveDir,
        );
      },
    );
  }
}
