import 'package:camera/camera.dart';
import '../persistence/app_state.dart';
import '../utils/directory_utils.dart';

Future<AppState> initializeCollectionModel(
    List<CameraDescription> cameras) async {
  final saveDir = await getReleasePicsSaveDir();
  final model = AppState(saveDir: saveDir.path, cameras: cameras);
  model.setInitialState([]);
  return model;
}
