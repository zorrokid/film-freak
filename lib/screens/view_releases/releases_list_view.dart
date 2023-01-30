import 'package:film_freak/persistence/query_specs/release_query_specs.dart';
import 'package:film_freak/screens/add_or_edit_release/bloc/add_or_edit_release_bloc.dart';
import 'package:film_freak/screens/add_or_edit_release/view/add_or_edit_release_page.dart';
import 'package:film_freak/services/collection_item_service.dart';
import 'package:film_freak/services/release_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/list_models/release_list_model.dart';
import '../../widgets/error_display_widget.dart';
import '../../widgets/main_drawer.dart';
import '../../utils/dialog_utls.dart';
import '../../persistence/app_state.dart';
import '../../widgets/release_filter_list.dart';
import '../../widgets/spinner.dart';
import '../add_or_edit_release/view/release_form.dart';
import '../view_release/view/release_page.dart';

class ReleasesListView extends StatefulWidget {
  final ReleaseService releaseService;
  const ReleasesListView({
    required this.releaseService,
    this.filter,
    super.key,
  });

  final ReleaseQuerySpecs? filter;

  @override
  State<StatefulWidget> createState() {
    return _ReleasesListViewState();
  }
}

class _ReleasesListViewState extends State<ReleasesListView> {
  late Future<List<ReleaseListModel>> _futureReleasesResult;

  @override
  void initState() {
    super.initState();
    _futureReleasesResult = _getResults();
  }

  Future<List<ReleaseListModel>> _getResults() async {
    return (await widget.releaseService.getListModels()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, appState, child) {
      void addRelease() {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return const AddOrEditReleasePage(
            barcode: 'TODO',
          );
        }));
      }

      Future<void> onDelete(int id) async {
        final isOkToDelete = await confirm(context, 'Are you sure?',
            '''Are you really sure you want to delete the release 
            and collection items related to it?''');
        if (!isOkToDelete) return;
        await widget.releaseService.delete(id);
      }

      Future<void> onCreate(int id) async {}

      Future<void> onEdit(int id) async {
        await Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return AddOrEditReleasePage(
              id: id,
            );
          },
        ));
      }

      Future<void> navigate(int id) async {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return ReleasePage(releaseId: id);
          },
        ));
      }

      return Scaffold(
        drawer: MainDrawer(
          releaseService: widget.releaseService,
          collectionItemService: initializeCollectionItemService(),
        ),
        appBar: AppBar(
          title: const Text('Releases'),
        ),
        body: FutureBuilder(
          future: _futureReleasesResult,
          builder: (BuildContext context,
              AsyncSnapshot<List<ReleaseListModel>> snapshot) {
            if (snapshot.hasError) {
              return ErrorDisplayWidget(snapshot.error.toString());
            }
            if (!snapshot.hasData) {
              return const Spinner();
            }
            return ReleaseFilterList(
              saveDir: appState.saveDir,
              onDelete: onDelete,
              onEdit: onEdit,
              onTap: navigate,
              releases: snapshot.data!,
              onCreate: onCreate,
            );
          },
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
