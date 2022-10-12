import 'package:film_freak/models/media_type.dart';
import 'package:film_freak/models/movie_releases_list_filter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_movie_release_form.dart';
import 'collection_model.dart';
import 'models/movie_release.dart';

class MovieReleasesList extends StatelessWidget {
  const MovieReleasesList({this.filter, super.key});

  final MovieReleasesListFilter? filter;

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
    return Consumer<CollectionModel>(builder: (context, cart, child) {
      List<MovieRelease> items = filterReleases(cart.movieReleases, filter);

      if (filter != null) {
        if (filter!.barcode != null) {
          items = items.where((i) => i.barcode == filter!.barcode).toList();
        }
      }

      void addRelease() {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return const AddMovieReleaseForm();
        }));
      }

      return Scaffold(
        appBar: AppBar(title: const Text('Results')),
        body: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                title: Text(item.barcode),
                subtitle: Text(mediaTypeFormFieldValues[item.mediaType] ?? ""),
              );
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
