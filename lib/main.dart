import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import 'package:film_freak/screens/scan_view.dart';
import 'package:film_freak/init/logging.dart';
import 'init/remote_config.dart';
import 'init/state.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initializeRemoteConfig();

  initializeLogging();
  cameras = await availableCameras();
  runApp(
    ChangeNotifierProvider(
        create: (context) => initializeCollectionModel(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'film_freak', home: ScanView());
  }
}
