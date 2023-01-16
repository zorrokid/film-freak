import 'package:film_freak/persistence/query_specs/release_query_specs.dart';
import 'package:film_freak/services/release_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../persistence/query_specs/collection_item_query_specs.dart';
import '../../models/list_models/collection_item_list_model.dart';
import '../../widgets/main_drawer.dart';
import '../../utils/dialog_utls.dart';
import '../../persistence/app_state.dart';
import '../../widgets/release_filter_list.dart';
import '../add_or_edit_release/release_form.dart';

class ReleasesListView extends StatefulWidget {
  const ReleasesListView({this.filter, super.key});

  final ReleaseQuerySpecs? filter;

  @override
  State<StatefulWidget> createState() {
    return _ReleasesListViewState();
  }
}

class _ReleasesListViewState extends State<ReleasesListView> {
  final releaseService = initializeReleaseService();

  @override
  void initState() {
    super.initState();
  }

  List<ReleaseListModel> filterReleases(
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
            'Are you really sure you want to dele<void>te the item?');
        if (!isOkToDelete) return;
        await releaseService.delete(id);
        // TODO: data from CollectionModel is not used here
        //cart.remove(id);
      }

      Future<void> onCreate(int id) async {}

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
        body: ReleaseFilterList(
          saveDir: appState.saveDir,
          onDelete: onDelete,
          onEdit: onEdit,
          releases: [],
          onCreate: onCreate,
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
