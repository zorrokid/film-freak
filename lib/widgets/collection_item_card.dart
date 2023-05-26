import 'package:flutter/material.dart';
import '../domain/enums/collection_status.dart';
import '../domain/enums/condition.dart';
import '../widgets/labelled_text.dart';
import '../domain/entities/collection_item.dart';

typedef OnCollectionItemEdit = void Function(int collectionItemId);
typedef OnCollectionItemDelete = void Function(int collectionItemId);

class CollectionItemCard extends StatelessWidget {
  const CollectionItemCard({
    super.key,
    required this.collectionItem,
    required this.onEdit,
    required this.onDelete,
  });
  final CollectionItem collectionItem;
  final OnCollectionItemEdit onEdit;
  final OnCollectionItemDelete onDelete;

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
          Row(children: [
            TextButton(
              onPressed: () => onDelete(collectionItem.id!),
              child: const Text("Delete"),
            ),
            TextButton(
              onPressed: () => onEdit(collectionItem.id!),
              child: const Text("Edit"),
            ),
          ]),
        ],
      ),
    );
  }
}
