import 'package:film_freak/persistence/collection_model.dart';
import 'package:film_freak/enums/case_type.dart';
import 'package:film_freak/entities/release.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
      'Movie releases total count should increase by one after adding a movie release.',
      () {
    final model = CollectionModel(saveDir: '');

    model.addListener(() {
      expect(model.totalMovieReleases, 1);
    });

    model.add(Release(
      name: 'Star Wars',
      barcode: '',
      caseType: CaseType.regularDvd,
    ));
  });
}
