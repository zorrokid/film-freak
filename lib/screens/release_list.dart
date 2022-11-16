import 'package:film_freak/models/movie_releases_list_filter.dart';
import 'package:film_freak/services/movie_release_service.dart';
import 'package:film_freak/widgets/main_drawer.dart';
import 'package:film_freak/widgets/release_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/error_display_widget.dart';
import '../widgets/spinner.dart';
import 'release_form.dart';
import '../persistence/collection_model.dart';
import '../entities/movie_release.dart';

class MovieReleasesList extends StatefulWidget {
  const MovieReleasesList({this.filter, super.key});

  final MovieReleasesListFilter? filter;

  @override
  State<StatefulWidget> createState() {
    return _MovieReleasesListState();
  }
}

class _MovieReleasesListState extends State<MovieReleasesList> {
  late Future<List<MovieRelease>> _futureGetReleases;
  final releaseService = MovieReleaseService();

  @override
  void initState() {
    super.initState();
    _futureGetReleases = _getReleases();
  }

  Future<List<MovieRelease>> _getReleases() async {
    return (await releaseService.getMovieReleases()).toList();
  }

  List<MovieRelease> filterReleases(
      List<MovieRelease> releases, MovieReleasesListFilter? filter) {
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
    //MovieReleasesListFilter? filter;
    return Consumer<CollectionModel>(builder: (context, cart, child) {
      // List<MovieRelease> items = filterReleases(cart.movieReleases, filter);

      // if (filter != null) {
      //   if (filter.barcode != null) {
      //     items = items.where((i) => i.barcode == filter.barcode).toList();
      //   }
      // }

      void addRelease() {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return const ReleaseForm();
        }));
      }

      return Scaffold(
        drawer: const MainDrawer(),
        appBar: AppBar(title: const Text('Results')),
        body: FutureBuilder(
            future: _futureGetReleases,
            builder:
                (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.hasError) {
                return ErrorDisplayWidget(snapshot.error.toString());
              }
              if (!snapshot.hasData) {
                return const Spinner();
              }
              //cart.movieReleases.addAll(snapshot.data! as List<MovieRelease>);
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ReleaseListTile(release: snapshot.data![index]);
                  });
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: addRelease,
          backgroundColor: Colors.green,
          child: const Icon(Icons.add),
        ),
      );
    });
  }
}
