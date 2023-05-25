import 'package:camera/camera.dart';
import '../persistence/app_state.dart';
import '../utils/directory_utils.dart';

Future<AppStateOld> initializeCollectionModel(
    List<CameraDescription> cameras) async {
  final saveDir = await getReleasePicsSaveDir();
  final model = AppStateOld(saveDir: saveDir.path, cameras: cameras);
  model.setInitialState([]);
  return model;
}
