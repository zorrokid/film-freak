import 'package:film_freak/enums/condition.dart';
import 'package:film_freak/enums/media_type.dart';
import 'package:film_freak/models/collection_item_media_view_model.dart';
import 'package:flutter/material.dart';

import '../../widgets/form/dropdown_form_field.dart';

typedef OnCollectionItemMediaUpdate = void Function(
    int index, Condition condition);

class CollectionItemMediaEditCard extends StatelessWidget {
  final CollectionItemMediaViewModel viewModel;
  final OnCollectionItemMediaUpdate onUpdate;
  final int index;
  const CollectionItemMediaEditCard({
    super.key,
    required this.viewModel,
    required this.onUpdate,
    required this.index,
  });

  String getTitle() {
    final mediaTypeName =
        mediaTypeFormFieldValues[viewModel.releaseMedia.mediaType]!;
    return '$index: $mediaTypeName';
  }

  void onValueChanged(Condition? condition) {
    if (condition == null) return;
    onUpdate(index, condition);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          DropdownFormField<Condition>(
            initialValue: Condition.unknown,
            values: conditionFormFieldValues,
            labelText: getTitle(),
            onValueChange: onValueChanged,
          ),
        ],
      ),
    );
  }
}
