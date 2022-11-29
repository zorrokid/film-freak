import 'package:film_freak/widgets/release_list.dart';
import 'package:film_freak/widgets/spinner.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/collection_item_list_model.dart';
import '../persistence/collection_model.dart';
import 'error_display_widget.dart';

typedef MovieReleaseFetchMethod = Future<Iterable<CollectionItemListModel>>
    Function();

class FilterList extends StatefulWidget {
  const FilterList(
      {super.key,
      required this.fetchMethod,
      required this.onDelete,
      required this.onEdit});

  final MovieReleaseFetchMethod fetchMethod;
  final OnDeleteCallback onDelete;
  final OnEditCallback onEdit;

  @override
  State<FilterList> createState() {
    return _FilterListState();
  }
}

class _FilterListState extends State<FilterList> {
  late Future<Iterable<CollectionItemListModel>>
      _futureCollectionItemListModels;

  @override
  void initState() {
    super.initState();
    _futureCollectionItemListModels = widget.fetchMethod();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> onDelete(int id) async {
      await widget.onDelete(id);
      setState(() {
        _futureCollectionItemListModels = widget.fetchMethod();
      });
    }

    Future<void> onEdit(int id) async {
      await widget.onEdit(id);
      setState(() {
        _futureCollectionItemListModels = widget.fetchMethod();
      });
    }

    return Consumer<CollectionModel>(builder: (context, appState, child) {
      return FutureBuilder(
          future: _futureCollectionItemListModels,
          builder: (BuildContext context,
              AsyncSnapshot<Iterable<CollectionItemListModel>> snapshot) {
            if (snapshot.hasError) {
              return ErrorDisplayWidget(
                snapshot.error.toString(),
              );
            }
            if (!snapshot.hasData) {
              return const Spinner();
            }
            final collectionItems = snapshot.data!.toList();
            return ReleaseList(
              releases: collectionItems,
              onDelete: onDelete,
              onEdit: onEdit,
              saveDir: appState.saveDir,
            );
          });
    });
  }
}
