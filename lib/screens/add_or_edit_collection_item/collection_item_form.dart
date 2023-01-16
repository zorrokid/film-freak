import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/collection_item_media.dart';
import '../../domain/enums/collection_status.dart';
import '../../domain/entities/collection_item.dart';
import '../../domain/enums/condition.dart';
import '../../models/collection_item_edit_view_model.dart';
import '../../models/collection_item_media_view_model.dart';
import '../../models/collection_item_save_model.dart';
import '../../services/release_service.dart';
import '../../services/collection_item_service.dart';
import '../../widgets/error_display_widget.dart';
import '../../widgets/spinner.dart';
import '../../widgets/form/dropdown_form_field.dart';
import '../../persistence/app_state.dart';
import 'collection_item_media_edit_card.dart';

class CollectionItemForm extends StatefulWidget {
  final int releaseId;
  final int? id;
  final CollectionItemService collectionItemService;
  final ReleaseService releaseService;

  const CollectionItemForm({
    required this.releaseService,
    required this.collectionItemService,
    required this.releaseId,
    this.id,
    super.key,
  });

  @override
  State<CollectionItemForm> createState() {
    return _CollectionItemFormState();
  }
}

class _CollectionItemFormState extends State<CollectionItemForm> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();

  // form state
  late Future<CollectionItemEditViewModel> _futureModel;
  Condition _condition = Condition.unknown;
  CollectionStatus _status = CollectionStatus.unknown;
  List<CollectionItemMedia> _media = <CollectionItemMedia>[];

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

  Future<CollectionItemEditViewModel> _loadData() async {
    final model = widget.id != null
        ? await widget.collectionItemService.getEditModel(widget.id!)
        : await widget.collectionItemService
            .initializeAddModel(widget.releaseId);

    _condition = model.collectionItem.condition;
    _status = model.collectionItem.status;
    _media = model.media.map((e) => e.collectionItemMedia).toList();

    // do not setState!

    return model;
  }

  CollectionItemSaveModel _buildModel() => CollectionItemSaveModel(
        collectionItem: CollectionItem(
          id: widget.id,
          releaseId: widget.releaseId,
          condition: _condition,
          status: _status,
        ),
        media: _media,
        properties: [],
      );

  void onUpdateCollectionItemMedia(int index, Condition condition) {
    final oldMedia = _media[index];
    _media[index] = CollectionItemMedia(
      releaseMediaId: oldMedia.releaseMediaId,
      id: oldMedia.id,
      collectionItemId: oldMedia.collectionItemId,
      createdTime: oldMedia.createdTime,
      modifiedTime: oldMedia.modifiedTime,
      condition: condition,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, appState, child) {
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

        viewModel.collectionItem.id =
            await widget.collectionItemService.upsert(viewModel);

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
          builder: (BuildContext context,
              AsyncSnapshot<CollectionItemEditViewModel> snapshot) {
            if (snapshot.hasError) {
              return ErrorDisplayWidget(snapshot.error.toString());
            }
            if (!snapshot.hasData) {
              return const Spinner();
            }

            final CollectionItem viewModel = snapshot.data!.collectionItem;
            final List<CollectionItemMediaViewModel> media =
                snapshot.data!.media;

            return Form(
              key: _formKey,
              child: Column(
                children: [
                  DropdownFormField(
                    initialValue: viewModel.condition,
                    values: conditionFormFieldValues,
                    onValueChange: onConditionSelected,
                    labelText: 'Condition',
                  ),
                  DropdownFormField(
                    initialValue: viewModel.status,
                    values: collectionStatusFieldValues,
                    onValueChange: onStatusSelected,
                    labelText: 'Status',
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: media.length,
                      itemBuilder: (BuildContext context, int index) {
                        return CollectionItemMediaEditCard(
                          index: index,
                          viewModel: media[index],
                          onUpdate: onUpdateCollectionItemMedia,
                        );
                      }),
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
