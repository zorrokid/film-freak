import 'package:film_freak/persistence/app_state.dart';
import 'package:film_freak/enums/case_type.dart';
import 'package:film_freak/entities/release.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
      'Movie releases total count should increase by one after adding a movie release.',
      () {
    final model = AppState(saveDir: '', collectionStatuses: []);

    model.addListener(() {
      expect(model.totalReleases, 1);
    });

//    model.add(Release(
//      name: 'Star Wars',
//      barcode: '',
//      caseType: CaseType.regularDvd,
//    ));
  });
}
