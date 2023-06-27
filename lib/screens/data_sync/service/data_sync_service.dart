import 'dart:convert';

import 'package:film_freak/services/release_service.dart';

import '../../../init/remote_config.dart';
import '../../../services/film_freak_api_client.dart';

initializeDataSyncService() => DataSyncService(
      releaseService: initializeReleaseService(),
    );

class DataSyncService {
  DataSyncService({required this.releaseService});

  final ReleaseService releaseService;

  final apiHost = remoteConfig.getString(remoteConfigKeyFilmFreakApiHost);

  final apiClient = FilmFreakApiClient();
  void synchronizeData(int batchSize, int currentBatch) {}

  Future<void> upload() async {
    final releases = await releaseService.getListModels();
    if (releases.isEmpty) return;
    final firstRelease = releases.first;

    final res = await apiClient.post(
        'release',
        jsonEncode({
          'id': firstRelease.id,
          'createdTime': DateTime.now().toIso8601String(),
          'modifiedTime': DateTime.now().toIso8601String(),
          'name': firstRelease.name,
          'barcode': firstRelease.barcode,
          'externalId': firstRelease.id,
        }));
  }
}
