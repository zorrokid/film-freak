import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:film_freak/models/movie_release.dart';

class CollectionModel extends ChangeNotifier {
  final List<MovieRelease> _movieReleases = [];

  UnmodifiableListView<MovieRelease> get movieReleases =>
      UnmodifiableListView(_movieReleases);

  UnmodifiableListView<MovieRelease> get recentReleases =>
      UnmodifiableListView(_recent);

  int get totalMovieReleases => movieReleases.length;

  final Queue<MovieRelease> _recent = Queue<MovieRelease>();

  void add(MovieRelease movieRelease) {
    _movieReleases.add(movieRelease);
    if (_recent.length == 10) {
      _recent.removeFirst();
    }
    _recent.add(movieRelease);
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
