import 'dart:collection';

import 'package:film_freak/realm_models/schema.dart';
import 'package:flutter/foundation.dart';

class AppState extends ChangeNotifier {
  AppState({required this.saveDir, required this.collectionStatuses});
  final List<CollectionStatus> collectionStatuses;
  final List<Release> _releases = [];
  String saveDir;

  UnmodifiableListView<Release> get releases => UnmodifiableListView(_releases);

  UnmodifiableListView<Release> get recentReleases =>
      UnmodifiableListView(_recent);

  int get totalReleases => releases.length;

  final Queue<Release> _recent = Queue<Release>();

  void add(Release release) {
    _releases.add(release);
    if (_recent.length == 10) {
      _recent.removeFirst();
    }
    _recent.add(release);
    notifyListeners();
  }

  void reset(Iterable<Release> movieReleases, bool notify) {
    _releases.clear();
    _releases.addAll(movieReleases);
    if (notify) {
      notifyListeners();
    }
  }

  void update(Release release) {
    _releases.removeWhere((element) => element.id == release.id);
    _recent.removeWhere((element) => element.id == release.id);
    add(release);
  }

  void removeAll() {
    _releases.clear();
    _recent.clear();
    notifyListeners();
  }

//  void remove(int id) {
//    _releases.removeWhere((e) => e.id == id);
//    _recent.removeWhere((e) => e.id == id);
//    notifyListeners();
//  }

  void setInitialState(List<Release> releases) {
    _releases.addAll(releases);
  }
}
