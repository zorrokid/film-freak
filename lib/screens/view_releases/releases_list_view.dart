import 'package:film_freak/persistence/query_specs/release_query_specs.dart';
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
  late Future<List<ReleaseListModel>> _futureReleasesResult;

  @override
  void initState() {
    super.initState();
    _futureReleasesResult = _getResults();
  }

  Future<List<ReleaseListModel>> _getResults() async {
    return (await releaseService.getListModels()).toList();
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
            '''Are you really sure you want to delete the release 
            and collection items related to it?''');
        if (!isOkToDelete) return;
        await releaseService.delete(id);
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
