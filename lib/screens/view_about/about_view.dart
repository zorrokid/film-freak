import 'package:film_freak/bloc/app_bloc.dart';
import 'package:film_freak/bloc/app_state.dart';
import 'package:film_freak/widgets/labelled_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/app_event.dart';
import '../../bloc/user_bloc.dart';
import '../../bloc/user_state.dart';
import '../../widgets/main_drawer.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(builder: (context, appState) {
      final appBloc = context.read<AppBloc>();
      appBloc.add(const GetSqliteVersion());
      appBloc.add(const GetReleaseCount());
      appBloc.add(const GetCollectionItemCount());
      appBloc.add(const GetFileCount());
      return BlocBuilder<UserBloc, UserState>(
          builder: (context, userBlocState) {
        final loggedInTxt = userBlocState.status == UserStatus.loggedIn
            ? "Logged in"
            : "Not logged in";
        return Scaffold(
          drawer: const MainDrawer(),
          appBar: AppBar(
            title: const Text('About film_freak'),
          ),
          body: Column(
            children: [
              const Center(child: Text('Copyright 2022-23 Mikko Keinänen')),
              Center(child: Text(loggedInTxt)),
              Center(
                child: Text('Sqlite Version: ${appState.sqliteVersion}'),
              ),
              Center(
                child: Text('Release count: ${appState.releaseCount}'),
              ),
              Center(
                child: Text(
                    'Collection item count: ${appState.collectionItemCount}'),
              ),
              LabelledText(
                  label: 'Files in save folder:',
                  value: appState.fileCount.toString()),
            ],
          ),
        );
      });
    });
  }
}
