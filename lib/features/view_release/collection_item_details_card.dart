import 'package:flutter/material.dart';

import '../../entities/collection_item.dart';
import '../../enums/condition.dart';
import '../../widgets/labelled_text.dart';

class CollectionItemDetailsCard extends StatelessWidget {
  const CollectionItemDetailsCard({super.key, required this.release});
  final CollectionItem release;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: [
        Row(
          children: [
            LabelledText(
              label: 'Condition',
              value: conditionFormFieldValues[release.condition]!,
            ),
          ],
        ),
        if (release.notes.isNotEmpty)
          Row(
            children: [
              LabelledText(
                label: 'Notes',
                value: release.notes,
              ),
            ],
          ),
      ]),
    );
  }
}
