import 'package:film_freak/models/collection_item_view_model.dart';
import 'package:flutter/material.dart';

import '../../../enums/condition.dart';
import '../../../widgets/labelled_text.dart';

class CollectionItemDetailsCard extends StatelessWidget {
  const CollectionItemDetailsCard(
      {super.key, required this.collectionItemViewModel});
  final CollectionItemViewModel collectionItemViewModel;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: [
        Row(
          children: [
            LabelledText(
              label: 'Condition',
              value: conditionFormFieldValues[
                  collectionItemViewModel.collectionItem.condition]!,
            ),
          ],
        ),
        // TODO: show comments & properties
      ]),
    );
  }
}
