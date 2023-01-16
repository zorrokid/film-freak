import 'package:flutter/material.dart';
import '../domain/enums/collection_status.dart';
import '../domain/enums/condition.dart';
import '../widgets/labelled_text.dart';
import '../domain/entities/collection_item.dart';

class CollectionItemCard extends StatelessWidget {
  const CollectionItemCard({super.key, required this.collectionItem});
  final CollectionItem collectionItem;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(5),
      child: Column(
        children: [
          Row(children: [
            LabelledText(
              label: 'Condition',
              value: conditionFormFieldValues[collectionItem.condition]!,
            ),
          ]),
          Row(children: [
            LabelledText(
              label: 'Status',
              value: collectionStatusFieldValues[collectionItem.status]!,
            ),
          ]),
        ],
      ),
    );
  }
}
