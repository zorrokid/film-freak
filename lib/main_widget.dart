import 'package:film_freak/persistence/db_provider.dart';
import 'package:film_freak/persistence/repositories/system_info_repository.dart';
import 'package:film_freak/screens/data_sync/service/data_sync_service.dart';
import 'package:film_freak/services/collection_item_service.dart';
import 'package:film_freak/services/release_service.dart';
import 'package:film_freak/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'film_freak_app.dart';

class MainWidget extends StatelessWidget {
  const MainWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
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
          create: (_) => initializeDataSyncService(),
        ),
        RepositoryProvider<SystemInfoRepository>(
          create: (_) => SystemInfoRepository(
            DatabaseProviderSqflite.instance,
          ),
        ),
      ],
      child: const FilmFreakApp(),
    );
  }
}
