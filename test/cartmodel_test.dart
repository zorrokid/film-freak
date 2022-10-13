import 'package:film_freak/collection_model.dart';
import 'package:film_freak/models/case_type.dart';
import 'package:film_freak/models/condition.dart';
import 'package:film_freak/models/media_type.dart';
import 'package:film_freak/models/movie_release.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
      'Movie releases total count should increase by one after adding a movie release.',
      () {
    final model = CollectionModel();

    model.addListener(() {
      expect(model.totalMovieReleases, 1);
    });

    model.add(const MovieRelease(
        id: 1,
        mediaType: MediaType.dvd,
        name: 'Star Wars',
        barcode: '',
        caseType: CaseType.regularDvd,
        condition: Condition.unknown));
  });
}
