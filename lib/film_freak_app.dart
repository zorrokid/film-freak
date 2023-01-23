import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'screens/scan_barcode/view/barcode_scan_page.dart';
import 'services/collection_item_service.dart';
import 'services/release_service.dart';

class FilmFreakApp extends StatelessWidget {
  const FilmFreakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'film_freak',
      home: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<ReleaseService>(
            create: (context) => initializeReleaseService(),
          ),
          RepositoryProvider<CollectionItemService>(
            create: (context) => initializeCollectionItemService(),
          )
        ],
        child: const BarcodeScanPage(),
      ),
    );
  }
}
