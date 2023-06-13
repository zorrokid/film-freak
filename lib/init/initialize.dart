import 'logging.dart';
import 'remote_config.dart';

Future<void> initialize() async {
  await initializeRemoteConfig();
  initializeLogging();
}
