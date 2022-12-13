import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../enums/collection_status.dart';
import '../../widgets/error_display_widget.dart';
import '../../widgets/spinner.dart';
import '../../widgets/form/drop_down_form_field.dart';

import '../../entities/collection_item.dart';
import '../../persistence/collection_model.dart';
import '../../enums/condition.dart';

import '../../services/collection_item_service.dart';

class CollectionItemForm extends StatefulWidget {
  const CollectionItemForm({required this.releaseId, this.id, super.key});

  final int releaseId;
  final int? id;

  @override
  State<CollectionItemForm> createState() {
    return _CollectionItemFormState();
  }
}

class _CollectionItemFormState extends State<CollectionItemForm> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  final _collectionItemService = initializeCollectionItemService();

  // form state
  late Future<CollectionItem> _futureModel;
  Condition _condition = Condition.unknown;
  CollectionStatus _status = CollectionStatus.unknown;

  @override
  void initState() {
    super.initState();
    _futureModel = _loadData();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void onConditionSelected(Condition? selected) {
    setState(() {
      _condition = selected ?? Condition.unknown;
    });
  }

  void onStatusSelected(CollectionStatus? selected) {
    setState(() {
      _status = selected ?? CollectionStatus.unknown;
    });
  }

  bool isEditMode() => widget.id != null;

  Future<CollectionItem> _loadData() async {
    final model = widget.id != null
        ? await _collectionItemService.get(widget.id!)
        : CollectionItem.empty(widget.releaseId);

    _condition = model.condition;
    _status = model.status;

    // do not setState!

    return model;
  }

  CollectionItem _buildModel() => CollectionItem(
        id: widget.id,
        releaseId: widget.releaseId,
        condition: _condition,
        status: _status,
      );

  @override
  Widget build(BuildContext context) {
    return Consumer<CollectionModel>(builder: (context, appState, child) {
      Future<void> submit() async {
        if (!_formKey.currentState!.validate()) return;
        final viewModel = _buildModel();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: isEditMode()
                ? const Text('Updating collection item')
                : const Text('Adding collection item'),
          ),
        );

        viewModel.id = await _collectionItemService.upsert(viewModel);

        if (mounted) {
          Navigator.of(context).pop();
        }
      }

      return Scaffold(
        appBar: AppBar(
            title: isEditMode()
                ? const Text('Edit collection item')
                : const Text('Add a collection item')),
        body: FutureBuilder(
          future: _futureModel,
          builder:
              (BuildContext context, AsyncSnapshot<CollectionItem> snapshot) {
            if (snapshot.hasError) {
              return ErrorDisplayWidget(snapshot.error.toString());
            }
            if (!snapshot.hasData) {
              return const Spinner();
            }

            final CollectionItem viewModel = snapshot.data!;

            return Form(
              key: _formKey,
              child: ListView(
                children: [
                  DropDownFormField(
                    initialValue: viewModel.condition,
                    values: conditionFormFieldValues,
                    onValueChange: onConditionSelected,
                    labelText: 'Condition',
                  ),
                  DropDownFormField(
                    initialValue: viewModel.status,
                    values: collectionStatusFieldValues,
                    onValueChange: onStatusSelected,
                    labelText: 'Status',
                  ),
                ],
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: submit,
          backgroundColor: Colors.green,
          child: const Icon(Icons.save),
        ),
      );
    });
  }
}
