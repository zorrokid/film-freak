import 'package:film_freak/persistence/collection_model.dart';
import 'package:film_freak/enums/case_type.dart';
import 'package:film_freak/enums/condition.dart';
import 'package:film_freak/enums/media_type.dart';
import 'package:film_freak/entities/movie_release.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
      'Movie releases total count should increase by one after adding a movie release.',
      () {
    final model = CollectionModel();

    model.addListener(() {
      expect(model.totalMovieReleases, 1);
    });

    model.add(MovieRelease.full(1, DateTime.now(), DateTime.now(),
        mediaType: MediaType.dvd,
        name: 'Star Wars',
        barcode: '',
        caseType: CaseType.regularDvd,
        condition: Condition.unknown,
        notes: '',
        hasSlipCover: false));
  });
}
