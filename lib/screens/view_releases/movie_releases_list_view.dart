import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../persistence/query_specs/collection_item_query_specs.dart';
import '../../models/list_models/collection_item_list_model.dart';
import '../../services/collection_item_service.dart';
import '../../widgets/main_drawer.dart';
import '../../widgets/collection_item_filter_list.dart';
import '../../utils/dialog_utls.dart';
import '../../persistence/app_state.dart';
import '../add_or_edit_release/release_form.dart';

class CollectionList extends StatefulWidget {
  const CollectionList({this.filter, super.key});

  final CollectionItemQuerySpecs? filter;

  @override
  State<StatefulWidget> createState() {
    return _CollectionListState();
  }
}

class _CollectionListState extends State<CollectionList> {
  final collectionItemService = initializeCollectionItemService();

  @override
  void initState() {
    super.initState();
  }

  List<CollectionItemListModel> filterReleases(
      List<CollectionItemListModel> collectionItems,
      CollectionItemQuerySpecs? filter) {
    if (filter == null) return collectionItems;

    if (filter.barcode != null) {
      return collectionItems
          .where((element) => element.barcode == filter.barcode)
          .toList();
    }

    return collectionItems;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, appState, child) {
      void addRelease() {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return const ReleaseForm();
        }));
      }

      Future<void> onDelete(int id) async {
        final isOkToDelete = await okToDelete(context, 'Are you sure?',
            'Are you really sure you want to delete the item?');
        if (!isOkToDelete) return;
        await collectionItemService.delete(id);
        // TODO: data from CollectionModel is not used here
        //cart.remove(id);
      }

      Future<void> onEdit(int id) async {
        await Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return ReleaseForm(
              id: id,
            );
          },
        ));
      }

      return Scaffold(
        drawer: const MainDrawer(),
        appBar: AppBar(
          title: const Text('Results'),
        ),
        body: CollectionItemFilterList(
          specs: widget.filter,
          saveDir: appState.saveDir,
          onDelete: onDelete,
          onEdit: onEdit,
          service: collectionItemService,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: addRelease,
          backgroundColor: Colors.green,
          child: const Icon(Icons.add),
        ),
      );
    });
  }
}
