import 'package:film_freak/widgets/collection_item_list_tile.dart';
import 'package:flutter/material.dart';

import '../../entities/production.dart';

class ProductionsList extends StatelessWidget {
  final List<Production> productions;
  final OnDeleteCallback onDelete;
  const ProductionsList({
    super.key,
    required this.productions,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Selected productions'),
        ListView.builder(
          shrinkWrap: true,
          itemCount: productions.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(productions[index].title),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => onDelete(productions[index].tmdbId!),
              ),
            );
          },
        ),
      ],
    );
  }
}
