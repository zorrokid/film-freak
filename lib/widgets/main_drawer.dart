import 'package:film_freak/bloc/app_event.dart';
import 'package:film_freak/screens/releases/view/releases_page.dart';
import 'package:film_freak/screens/data_sync/view/data_sync_view.dart';
import 'package:film_freak/utils/dialog_utls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/app_bloc.dart';
import '../bloc/app_state.dart';
import '../bloc/user_bloc.dart';
import '../bloc/user_state.dart';
import '../screens/log_in/view/log_in_page.dart';
import '/screens/view_about/about_view.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MainDrawerState();
  }
}

void _navigateFromDrawer(BuildContext context, Widget widget) {
  Navigator.pop(context);
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return widget;
  }));
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppBloc, AppState>(
      listener: (context, state) {
        if (state.status == AppStatus.dbResetDone) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Database reset done'),
              duration: Duration(seconds: 1),
            ),
          );
          _navigateFromDrawer(context, const ReleasesPage());
        }
      },
      builder: (context, state) {
        return BlocBuilder<UserBloc, UserState>(builder: (context, state) {
          final userBloc = context.read<UserBloc>();
          return Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(color: Colors.blue),
                  child: Text('Drawer header'),
                ),
                ListTile(
                  title: const Text('Releases'),
                  onTap: () =>
                      _navigateFromDrawer(context, const ReleasesPage()),
                ),
                userBloc.state.status == UserStatus.loggedOut
                    ? ListTile(
                        title: const Text('Log in'),
                        onTap: () =>
                            _navigateFromDrawer(context, const LogInPage()),
                      )
                    : ListTile(
                        title: const Text('Data'),
                        onTap: () =>
                            _navigateFromDrawer(context, const DataSyncView()),
                      ),
                /*ListTile(
              title: const Text('Import'),
              onTap: () => _navigateFromDrawer(
                  context,
                  ImportView(
                    fileImporter: FileImporter(
                        dbProvider: DatabaseProviderSqflite.instance),
                  )),
            ),*/
                ListTile(
                  title: const Text('Delete'),
                  onTap: () {
                    confirm(
                      context: context,
                      title: 'Confirm DB delete',
                      message:
                          'Are you really sure you want to delete all the data in database?',
                      onConfirm: () =>
                          context.read<AppBloc>().add(const ResetDb()),
                    );
                  },
                ),
                ListTile(
                  title: const Text('About'),
                  onTap: () => _navigateFromDrawer(context, const AboutView()),
                ),
              ],
            ),
          );
        });
      },
    );
  }
}
