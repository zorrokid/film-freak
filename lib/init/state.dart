import 'package:film_freak/persistence/realm_provider.dart';
import 'package:film_freak/realm_models/schema.dart';

import '../persistence/app_state.dart';
import '../utils/directory_utils.dart';

Future<AppState> initializeCollectionModel() async {
  final saveDir = await getReleasePicsSaveDir();
  final realm = RealmProvider.openRealm();
  final collectionStatuses = realm.all<CollectionStatus>().toList();
  final model =
      AppState(saveDir: saveDir.path, collectionStatuses: collectionStatuses);
  model.setInitialState([]);
  return model;
}
