import 'package:film_freak/models/media_type.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'collection_model.dart';

class MovieReleasesList extends StatelessWidget {
  const MovieReleasesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CollectionModel>(builder: (context, cart, child) {
      return ListView.builder(
          itemCount: cart.totalMovieReleases,
          itemBuilder: (context, index) {
            final item = cart.movieReleases[index];
            return ListTile(
              title: Text(item.name),
              subtitle: Text(item.mediaType.toUiString()),
            );
          });
    });
  }
}
