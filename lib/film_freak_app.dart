import 'package:film_freak/bloc/user_bloc.dart';
import 'package:film_freak/persistence/repositories/system_info_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/app_bloc.dart';
import 'screens/releases/view/releases_page.dart';

class FilmFreakApp extends StatelessWidget {
  const FilmFreakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(
          create: (_) => UserBloc(),
        ),
        BlocProvider<AppBloc>(
            create: (_) => AppBloc(
                  systemInfoRepository: context.read<SystemInfoRepository>(),
                )),
      ],
      child: const MaterialApp(
        title: 'film_freak',
        home: ReleasesPage(),
      ),
    );
  }
}
