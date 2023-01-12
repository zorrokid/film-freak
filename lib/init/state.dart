import '../persistence/app_state.dart';
import '../utils/directory_utils.dart';

Future<AppState> initializeCollectionModel() async {
  final saveDir = await getReleasePicsSaveDir();
  final model = AppState(saveDir: saveDir.path);
  model.setInitialState([]);
  return model;
}
