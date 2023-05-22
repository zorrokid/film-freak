import 'package:film_freak/utils/snackbar_buillder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/models/collection_item_media_view_model.dart';
import '../../../services/collection_item_service.dart';
import '../../../domain/entities/collection_item.dart';
import '../../../models/collection_item_save_model.dart';
import 'add_or_edit_collection_item_event.dart';
import 'add_or_edit_collection_item_state.dart';

class AddOrEditCollectionItemBloc
    extends Bloc<AddOrEditCollectionItemEvent, AddOrEditCollectionItemState> {
  AddOrEditCollectionItemBloc(this.collectionItemService)
      : super(const AddOrEditCollectionItemState()) {
    on<LoadCollectionItem>(_onLoadCollectionItem);
    on<InitCollectionItem>(_onInitCollectionItem);
    on<UpdateCollectionItemMedia>(_onUpdateCollectionItemMedia);
    on<InitState>(_onInitState);
    on<Submit>(_onSubmit);
    on<SelectStatus>(_onSelectStatus);
    on<SelectCondition>(_onSelectCondition);
  }
  final CollectionItemService collectionItemService;

  void _onInitState(
    InitState event,
    Emitter<AddOrEditCollectionItemState> emit,
  ) {
    emit(state.copyWith(
      status: AddOrEditCollectionItemStatus.initializedState,
      collectionItemId: event.collectionItemId,
      releaseId: event.releaseId,
    ));
  }

  Future<void> _onSubmit(
    Submit event,
    Emitter<AddOrEditCollectionItemState> emit,
  ) async {
    final model = CollectionItemSaveModel(
      collectionItem: CollectionItem(
        id: state.collectionItemId,
        releaseId: state.releaseId,
        condition: state.condition,
        status: state.collectionStatus,
      ),
      media: state.media.map((e) => e.collectionItemMedia).toList(),
      properties: [],
    );
    ScaffoldMessenger.of(event.context).showSnackBar(
        SnackBarBuilder.buildSnackBar(state.collectionItemId != null
            ? 'Updating collection item'
            : 'Adding collection item'));

    final id = await collectionItemService.upsert(model);
    model.collectionItem.id = id;
    emit(state.copyWith(
      status: AddOrEditCollectionItemStatus.submitted,
      saveModel: model,
    ));
  }

  void _onUpdateCollectionItemMedia(
    UpdateCollectionItemMedia event,
    Emitter<AddOrEditCollectionItemState> emit,
  ) {
    final media = [...state.media];
    final oldMediaViewModel = media[event.index];
    final oldCollectionItemMedia = oldMediaViewModel.collectionItemMedia;
    media[event.index] = CollectionItemMediaViewModel(
        releaseMedia: oldMediaViewModel.releaseMedia,
        collectionItemMedia:
            oldCollectionItemMedia.copyWith(condition: event.condition));
    emit(state.copyWith(
        status: AddOrEditCollectionItemStatus.mediaUpdated, media: media));
  }

  Future<void> _onLoadCollectionItem(
    LoadCollectionItem event,
    Emitter<AddOrEditCollectionItemState> emit,
  ) async {
    emit(state.copyWith(
        status: AddOrEditCollectionItemStatus.loading,
        collectionItemId: event.collectionItemId));
    final model =
        await collectionItemService.getEditModel(event.collectionItemId);
    emit(
      state.copyWith(
        status: AddOrEditCollectionItemStatus.loaded,
        viewModel: model,
        condition: model.collectionItem.condition,
        collectionStatus: model.collectionItem.status,
        media: model.media,
      ),
    );
  }

  Future<void> _onInitCollectionItem(
    InitCollectionItem event,
    Emitter<AddOrEditCollectionItemState> emit,
  ) async {
    emit(state.copyWith(
        status: AddOrEditCollectionItemStatus.initializingCollectionItem,
        releaseId: event.releaseId));
    final model =
        await collectionItemService.initializeAddModel(event.releaseId);

    emit(
      state.copyWith(
        status: AddOrEditCollectionItemStatus.initializedCollectionItem,
        viewModel: model,
        condition: model.collectionItem.condition,
        collectionStatus: model.collectionItem.status,
        media: model.media,
      ),
    );
  }

  void _onSelectCondition(
    SelectCondition event,
    Emitter<AddOrEditCollectionItemState> emit,
  ) {
    emit(state.copyWith(
        status: AddOrEditCollectionItemStatus.edit,
        condition: event.condition));
  }

  void _onSelectStatus(
    SelectStatus event,
    Emitter<AddOrEditCollectionItemState> emit,
  ) {
    emit(state.copyWith(
        status: AddOrEditCollectionItemStatus.edit,
        collectionStatus: event.status));
  }
}
