import '../../../init/remote_config.dart';
import '../../../services/film_freak_api_client.dart';

class DataSyncService {
  final apiHost = remoteConfig.getString(remoteConfigKeyFilmFreakApiHost);

  final apiClient = FilmFreakApiClient();
  void synchronizeData(int batchSize, int currentBatch) {}
  Future<void> upload() async {
    final count = await apiClient.get('release');
  }
}
