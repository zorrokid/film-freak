import 'package:film_freak/widgets/release_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../persistence/collection_model.dart';

class RecentList extends StatefulWidget {
  const RecentList({super.key});

  @override
  State<RecentList> createState() {
    return _RecentListState();
  }
}

class _RecentListState extends State<RecentList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CollectionModel>(builder: (context, cart, child) {
      return ListView.builder(
          itemCount: cart.recentReleases.length,
          itemBuilder: (context, index) {
            return ReleaseListTile(release: cart.recentReleases[index]);
          });
    });
  }
}
