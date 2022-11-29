import 'package:film_freak/models/collection_item_query_specs.dart';
import 'package:film_freak/models/collection_item_list_model.dart';
import 'package:film_freak/services/collection_item_service.dart';
import 'package:film_freak/widgets/filter_list.dart';
import 'package:film_freak/widgets/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/dialog_utls.dart';
import 'release_form.dart';
import '../persistence/collection_model.dart';
import '../entities/movie_release.dart';

class MovieReleasesList extends StatefulWidget {
  const MovieReleasesList({this.filter, super.key});

  final CollectionItemQuerySpecs? filter;

  @override
  State<StatefulWidget> createState() {
    return _MovieReleasesListState();
  }
}

class _MovieReleasesListState extends State<MovieReleasesList> {
  final releaseService = initializeReleaseService();

  @override
  void initState() {
    super.initState();
  }

  Future<Iterable<CollectionItemListModel>> _getReleases() async =>
      await releaseService.getListModels(widget.filter);

  List<MovieRelease> filterReleases(
      List<MovieRelease> releases, CollectionItemQuerySpecs? filter) {
    if (filter == null) return releases;

    if (filter.barcode != null) {
      return releases
          .where((element) => element.barcode == filter.barcode)
          .toList();
    }

    return releases;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CollectionModel>(builder: (context, appState, child) {
      void addRelease() {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return const ReleaseForm();
        }));
      }

      Future<void> onDelete(int id) async {
        final isOkToDelete = await okToDelete(context, 'Are you sure?',
            'Are you really sure you want to delete the item?');
        if (!isOkToDelete) return;
        await releaseService.deleteRelease(id);
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
        body: FilterList(
          fetchMethod: _getReleases,
          onDelete: onDelete,
          onEdit: onEdit,
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
