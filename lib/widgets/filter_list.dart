import 'package:film_freak/widgets/release_list.dart';
import 'package:film_freak/widgets/spinner.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../entities/movie_release.dart';
import '../persistence/collection_model.dart';
import 'error_display_widget.dart';

typedef MovieReleaseFetchMethod = Future<List<MovieRelease>> Function();

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
  late Future<List<MovieRelease>> _futureMovieReleases;

  @override
  void initState() {
    super.initState();
    _futureMovieReleases = widget.fetchMethod();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> onDelete(int id) async {
      await widget.onDelete(id);
      setState(() {
        _futureMovieReleases = widget.fetchMethod();
      });
    }

    Future<void> onEdit(int id) async {
      await widget.onEdit(id);
      setState(() {
        _futureMovieReleases = widget.fetchMethod();
      });
    }

    return Consumer<CollectionModel>(builder: (context, cart, child) {
      return FutureBuilder(
          future: _futureMovieReleases,
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.hasError) {
              return ErrorDisplayWidget(
                snapshot.error.toString(),
              );
            }
            if (!snapshot.hasData) {
              return const Spinner();
            }
            final movieReleases = snapshot.data as List<MovieRelease>;
            return ReleaseList(
              releases: movieReleases,
              onDelete: onDelete,
              onEdit: onEdit,
            );
          });
    });
  }
}
