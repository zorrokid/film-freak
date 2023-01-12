import 'package:film_freak/enums/collection_status.dart';
import 'package:film_freak/enums/condition.dart';
import 'package:flutter/material.dart';
import '../../widgets/labelled_text.dart';
import '../entities/collection_item.dart';

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
