import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/media_type.dart';
import '../persistence/collection_model.dart';
import 'condition_icon.dart';

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
            final item = cart.recentReleases[index];
            return ListTile(
              title: Text(item.barcode),
              subtitle: Text(mediaTypeFormFieldValues[item.mediaType] ?? ""),
              trailing: ConditionIcon(condition: item.condition),
            );
          });
    });
  }
}
