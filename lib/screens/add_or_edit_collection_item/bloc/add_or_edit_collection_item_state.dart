import 'package:equatable/equatable.dart';

import '/models/collection_item_media_view_model.dart';
import '../../../models/collection_item_save_model.dart';
import '../../../domain/enums/collection_status.dart';
import '../../../domain/enums/condition.dart';
import '../../../models/collection_item_edit_view_model.dart';

enum AddOrEditCollectionItemStatus {
  initial,
  initializedState,
  loading,
  loaded,
  initializingCollectionItem,
  initializedCollectionItem,
  mediaUpdated,
  submitted,
  error,
  edit,
}

class AddOrEditCollectionItemState extends Equatable {
  const AddOrEditCollectionItemState({
    this.collectionItemId,
    this.releaseId = 0,
    this.status = AddOrEditCollectionItemStatus.initial,
    this.viewModel,
    this.saveModel,
    this.condition = Condition.unknown,
    this.collectionStatus = CollectionStatus.unknown,
    this.media = const <CollectionItemMediaViewModel>[],
    this.error = "",
  });

  AddOrEditCollectionItemState copyWith({
    int? collectionItemId,
    int? releaseId,
    AddOrEditCollectionItemStatus? status,
    CollectionItemEditViewModel? viewModel,
    CollectionItemSaveModel? saveModel,
    Condition? condition,
    CollectionStatus? collectionStatus,
    List<CollectionItemMediaViewModel>? media,
    String? error,
  }) {
    return AddOrEditCollectionItemState(
      collectionItemId: collectionItemId ?? this.collectionItemId,
      releaseId: releaseId ?? this.releaseId,
      status: status ?? this.status,
      viewModel: viewModel ?? this.viewModel,
      saveModel: saveModel ?? this.saveModel,
      condition: condition ?? this.condition,
      collectionStatus: collectionStatus ?? this.collectionStatus,
      media: media ?? this.media,
      error: error ?? this.error,
    );
  }

  final int? collectionItemId;
  final int releaseId;
  final AddOrEditCollectionItemStatus status;
  final CollectionItemEditViewModel? viewModel;
  final CollectionItemSaveModel? saveModel;
  final Condition condition;
  final CollectionStatus collectionStatus;
  final List<CollectionItemMediaViewModel> media;
  final String error;

  @override
  List<Object?> get props => [
        collectionItemId,
        releaseId,
        status,
        viewModel,
        saveModel,
        condition,
        collectionStatus,
        media,
        error,
      ];
}
