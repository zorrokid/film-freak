import 'package:camera/camera.dart';
import 'package:film_freak/persistence/db_provider.dart';
import 'package:film_freak/persistence/release_repository.dart';
import 'package:film_freak/scan_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:film_freak/collection_model.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  var model = CollectionModel();
  var releases =
      await ReleaseRepository(databaseProvider: DatabaseProvider.instance)
          .queryReleases();
  model.setInitialState(releases.toList());
  runApp(
    ChangeNotifierProvider(create: (context) => model, child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Film Freak', home: ScanView());
  }
}
