import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../bloc/add_or_edit_collection_item_bloc.dart';
import '../bloc/add_or_edit_collection_item_event.dart';
import '../bloc/add_or_edit_collection_item_state.dart';
import '../../../domain/enums/collection_status.dart';
import '../../../domain/enums/condition.dart';
import '../../../services/release_service.dart';
import '../../../services/collection_item_service.dart';
import '../../../widgets/error_display_widget.dart';
import '../../../widgets/spinner.dart';
import '../../../widgets/form/dropdown_form_field.dart';
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

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void collectionItemStateListener(
    BuildContext context,
    AddOrEditCollectionItemState state,
  ) {
    final bloc = context.read<AddOrEditCollectionItemBloc>();
    switch (state.status) {
      case AddOrEditCollectionItemStatus.initializedState:
        if (state.collectionItemId != null) {
          bloc.add(LoadCollectionItem(state.collectionItemId!));
        } else {
          bloc.add(InitCollectionItem(state.releaseId));
        }
        break;
      case AddOrEditCollectionItemStatus.submitted:
        Navigator.of(context).pop();
        break;
      default:
        // nothing to do
        break;
    }
  }

  Future<void> submit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    final bloc = context.read<AddOrEditCollectionItemBloc>();
    bloc.add(Submit(context));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddOrEditCollectionItemBloc,
        AddOrEditCollectionItemState>(
      listener: collectionItemStateListener,
      builder: (context, state) {
        if (state.status == AddOrEditCollectionItemStatus.error) {
          return ErrorDisplayWidget(state.error);
        }
        if (state.status == AddOrEditCollectionItemStatus.loading) {
          return const Spinner();
        }

        final bloc = context.read<AddOrEditCollectionItemBloc>();

        return Scaffold(
          appBar: AppBar(
            title: state.collectionItemId != null
                ? const Text('Edit collection item')
                : const Text('Add a collection item'),
          ),
          body: Form(
            key: _formKey,
            child: Column(
              children: [
                DropdownFormField(
                  initialValue: state.condition,
                  values: conditionFormFieldValues,
                  onValueChange: (Condition? condition) =>
                      bloc.add(SelectCondition(condition ?? Condition.unknown)),
                  labelText: 'Condition',
                ),
                DropdownFormField(
                  initialValue: state.collectionStatus,
                  values: collectionStatusFieldValues,
                  onValueChange: (CollectionStatus? status) => bloc
                      .add(SelectStatus(status ?? CollectionStatus.unknown)),
                  labelText: 'Status',
                ),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.media.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CollectionItemMediaEditCard(
                        index: index,
                        viewModel: state.media[index],
                        onUpdate: (int index, Condition condition) => bloc
                            .add(UpdateCollectionItemMedia(index, condition)),
                      );
                    }),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => submit(context),
            backgroundColor: Colors.green,
            child: const Icon(Icons.save),
          ),
        );
      },
    );
  }
}
