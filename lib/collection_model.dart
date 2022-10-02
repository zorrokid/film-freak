import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:film_freak/models/movie_release.dart';

class CollectionModel extends ChangeNotifier {
  final List<MovieRelease> _movieReleases = [];

  UnmodifiableListView<MovieRelease> get movieReleases =>
      UnmodifiableListView(_movieReleases);

  int get totalMovieReleases => movieReleases.length;

  void add(MovieRelease movieRelease) {
    _movieReleases.add(movieRelease);
    notifyListeners();
  }

  void removeAll() {
    _movieReleases.clear();
    notifyListeners();
  }

  void setInitialState(List<MovieRelease> releases) {
    _movieReleases.addAll(releases);
  }
}
