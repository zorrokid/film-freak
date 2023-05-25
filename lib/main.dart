import 'package:film_freak/persistence/db_provider.dart';
import 'package:film_freak/persistence/repositories/system_info_repository.dart';
import 'package:film_freak/screens/data_sync/service/data_sync_service.dart';
import 'package:film_freak/services/collection_item_service.dart';
import 'package:film_freak/services/release_service.dart';
import 'package:film_freak/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'film_freak_app.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import 'init/logging.dart';
import 'init/remote_config.dart';
import 'init/state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initializeRemoteConfig();
  final List<CameraDescription> cameras = await availableCameras();
  final collectionModel = await initializeCollectionModel(cameras);

  initializeLogging();
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ReleaseService>(
          create: (_) => initializeReleaseService(),
        ),
        RepositoryProvider<CollectionItemService>(
          create: (_) => initializeCollectionItemService(),
        ),
        RepositoryProvider<UserService>(
          create: (_) => UserService(),
        ),
        RepositoryProvider<DataSyncService>(
          create: (_) => DataSyncService(),
        ),
        RepositoryProvider<SystemInfoRepository>(
          create: (_) => SystemInfoRepository(
            DatabaseProviderSqflite.instance,
          ),
        ),
      ],
      child: ChangeNotifierProvider(
        create: (_) => collectionModel,
        child: const FilmFreakApp(),
      ),
    ),
  );
}
