import 'package:flutter/material.dart';

import '../../../domain/enums/condition.dart';
import '../../../domain/enums/media_type.dart';
import '../../../models/collection_item_media_view_model.dart';
import '../../../widgets/form/dropdown_form_field.dart';

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
