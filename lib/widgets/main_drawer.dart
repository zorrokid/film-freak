import 'package:film_freak/features/scan_barcode/scan_view.dart';
import 'package:film_freak/widgets/confirm_dialog.dart';
import 'package:film_freak/persistence/db_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../persistence/app_state.dart';
import '../screens/about_view.dart';
import '../screens/import_view.dart';
import '../screens/movie_releases_list_view.dart';
import '../services/file_importer.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MainDrawerState();
  }
}

class _MainDrawerState extends State<MainDrawer> {
  Future<void> _showDeleteConfirmDialog(
      BuildContext context, AppState cart) async {
    var okToDelete = await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return ConfirmDialog(
                  title: 'Are you sure?',
                  message:
                      'Are you really sure you want to delete all the data in database?',
                  onContinue: () {
                    Navigator.pop(context, true);
                  },
                  onCancel: () {
                    Navigator.pop(context, false);
                  });
            }) ??
        false;
    if (okToDelete && await DatabaseProviderSqflite.instance.truncateDb()) {
      cart.removeAll();
    }
  }

  void _navigateFromDrawer(BuildContext context, Widget widget) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return widget;
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, cart, child) {
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
              onTap: () => _navigateFromDrawer(context, const CollectionList()),
            ),
            ListTile(
              title: const Text('Scan'),
              onTap: () => _navigateFromDrawer(context, const ScanView()),
            ),
            ListTile(
              title: const Text('Import'),
              onTap: () => _navigateFromDrawer(
                  context,
                  ImportView(
                    fileImporter: FileImporter(
                        dbProvider: DatabaseProviderSqflite.instance),
                  )),
            ),
            ListTile(
              title: const Text('Delete'),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmDialog(context, cart);
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
  }
}
