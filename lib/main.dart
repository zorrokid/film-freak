import 'package:camera/camera.dart';
import 'package:film_freak/screens/scan_view.dart';
import 'package:film_freak/utils/logging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:film_freak/persistence/collection_model.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
