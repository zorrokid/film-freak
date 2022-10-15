import 'package:film_freak/widgets/confirm_dialog.dart';
import 'package:film_freak/persistence/db_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../persistence/collection_model.dart';
import '../screens/movie_releases_list.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MainDrawerState();
  }
}

class _MainDrawerState extends State<MainDrawer> {
  Future<void> _deleteDb(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return ConfirmDialog(
              title: 'Are you sure?',
              message:
                  'Are you really sure you want to delete all the data in database?',
              onContinue: () {
                DatabaseProvider.instance.truncateDb();
                Navigator.of(context).pop();
              },
              onCancel: () {
                Navigator.of(context).pop();
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CollectionModel>(builder: (context, cart, child) {
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
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const MovieReleasesList();
                }));
              },
            ),
            ListTile(
              title: const Text('Delete'),
              onTap: () {
                _deleteDb(context);
                cart.removeAll();
                Navigator.pop(context);
              },
            )
          ],
        ),
      );
    });
  }
}
