import 'package:firebase_remote_config/firebase_remote_config.dart';

final remoteConfig = FirebaseRemoteConfig.instance;

const remoteConfigKeyTmdbApiKey = 'tmdb_api_key';
const remoteConfigKeyFilmFreakApiHost = 'film_freak_api_host';

Future<void> initializeRemoteConfig() async {
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(minutes: 1),
    minimumFetchInterval: const Duration(hours: 1),
  ));

  await remoteConfig.setDefaults(const {
    remoteConfigKeyTmdbApiKey: '',
    remoteConfigKeyFilmFreakApiHost: '',
  });
  await remoteConfig.fetchAndActivate();
}
