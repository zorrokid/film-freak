import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:film_freak/entities/movie_release.dart';

class CollectionModel extends ChangeNotifier {
  CollectionModel({required this.saveDir});
  final List<MovieRelease> _movieReleases = [];
  String saveDir;

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

  void reset(Iterable<MovieRelease> movieReleases, bool notify) {
    _movieReleases.clear();
    _movieReleases.addAll(movieReleases);
    if (notify) {
      notifyListeners();
    }
  }

  void update(MovieRelease movieRelease) {
    _movieReleases.removeWhere((element) => element.id == movieRelease.id);
    _recent.removeWhere((element) => element.id == movieRelease.id);
    add(movieRelease);
  }

  void removeAll() {
    _movieReleases.clear();
    _recent.clear();
    notifyListeners();
  }

  void remove(int id) {
    _movieReleases.removeWhere((element) => element.id == id);
    _recent.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  void setInitialState(List<MovieRelease> releases) {
    _movieReleases.addAll(releases);
  }
}
