import 'package:film_freak/screens/barcode_scan/view/barcode_scan_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/services/collection_item_service.dart';
import '/services/release_service.dart';
import '/widgets/confirm_dialog.dart';
import '/persistence/db_provider.dart';
import '/persistence/app_state.dart';
import '/screens/view_about/about_view.dart';

class MainDrawer extends StatefulWidget {
  final ReleaseService releaseService;
  final CollectionItemService collectionItemService;
  const MainDrawer({
    super.key,
    required this.releaseService,
    required this.collectionItemService,
  });

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
              onTap: () =>
                  _navigateFromDrawer(context, const BarcodeScanPage()),
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
