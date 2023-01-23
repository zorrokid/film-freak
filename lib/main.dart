import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
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
    ChangeNotifierProvider(
      create: (context) => collectionModel,
      child: const FilmFreakApp(),
    ),
  );
}
