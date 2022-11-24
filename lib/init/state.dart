import '../persistence/collection_model.dart';

CollectionModel initializeCollectionModel() {
  final model = CollectionModel();
  model.setInitialState([]);
  return model;
}
