import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/error_display_widget.dart';
import '../../widgets/spinner.dart';
import '../../widgets/form/drop_down_form_field.dart';
import '../../widgets/form/decorated_text_form_field.dart';

import '../../entities/collection_item.dart';
import '../../persistence/collection_model.dart';
import '../../enums/condition.dart';

import '../../services/collection_item_service.dart';

class CollectionItemForm extends StatefulWidget {
  const CollectionItemForm({this.id, this.releaseId, super.key});

  final int? id;
  final int? releaseId;

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
  late int? _id;
  Condition _condition = Condition.unknown;
  bool? _hasSlipCover;

  @override
  void initState() {
    super.initState();
    _id = widget.id;
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

  void hasSlipCoverChanged(bool? value) {
    setState(() {
      _hasSlipCover = value;
    });
  }

  bool isEditMode() => _id != null;

  Future<CollectionItem> _loadData() async {
    if (widget.id == null && widget.releaseId == null) {
      // TODO log error
      throw Exception('Either id or releaseId must be set!');
    }
    final model = _id == null
        ? CollectionItem.empty(widget.releaseId!)
        : await _collectionItemService.get(_id!);

    _notesController.text = model.notes;
    _condition = model.condition;

    // do not setState!

    return model;
  }

  CollectionItem _buildModel() {
    final collectionItem = CollectionItem(
      id: _id,
      releaseId: widget.releaseId,
      condition: _condition,
      hasSlipCover: _hasSlipCover ?? false,
      notes: _notesController.text,
    );
    return collectionItem;
  }

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
                  Row(
                    children: [
                      Expanded(
                        child: DecoratedTextFormField(
                          controller: _notesController,
                          label: 'Notes',
                          required: false,
                          maxLines: 3,
                        ),
                      ),
                    ],
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
