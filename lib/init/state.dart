import '../persistence/collection_model.dart';
import '../utils/directory_utils.dart';

Future<CollectionModel> initializeCollectionModel() async {
  final saveDir = await getReleasePicsSaveDir();
  final model = CollectionModel(saveDir: saveDir.path);
  model.setInitialState([]);
  return model;
}
