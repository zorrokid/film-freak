import 'package:film_freak/screens/add_or_edit_release/view/add_or_edit_release_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/collection_item_service.dart';
import '../../../services/release_service.dart';
import '../../add_or_edit_collection_item/view/add_or_edit_collection_item_page.dart';
import 'release_view_event.dart';
import 'release_view_state.dart';

class ReleaseViewBloc extends Bloc<ReleaseViewEvent, ReleaseViewState> {
  ReleaseViewBloc({
    required this.releaseService,
    required this.collectionItemService,
  }) : super(const ReleaseViewState()) {
    on<LoadRelease>(_loadRelease);
    on<EditRelease>(_editRelease);
    on<EditCollectionItem>(_editCollectionItem);
    on<DeleteCollectionItem>(_deleteCollectionItem);
  }
  final ReleaseService releaseService;
  final CollectionItemService collectionItemService;

  Future<void> _loadRelease(
    LoadRelease event,
    Emitter<ReleaseViewState> emit,
  ) async {
    emit(state.copyWith(
        status: ReleaseViewStatus.loading, releaseId: event.releaseId));
    final model = await releaseService.getModel(event.releaseId);
    emit(state.copyWith(status: ReleaseViewStatus.loaded, release: model));
  }

  Future<void> _editRelease(
    EditRelease event,
    Emitter<ReleaseViewState> emit,
  ) async {
    emit(state.copyWith(status: ReleaseViewStatus.startEditing));
    await Navigator.push(
      event.context,
      MaterialPageRoute(
        builder: (context) => AddOrEditReleasePage(
          id: event.releaseId,
        ),
      ),
    );
    emit(state.copyWith(status: ReleaseViewStatus.edited));
  }

  Future<void> _editCollectionItem(
    EditCollectionItem event,
    Emitter<ReleaseViewState> emit,
  ) async {
    await Navigator.push(
      event.context,
      MaterialPageRoute(
        builder: (context) => AddOrEditCollectionItemPage(
          collectionItemId: event.collectionItemId,
          releaseId: event.releaseId,
        ),
      ),
    );
    emit(state.copyWith(status: ReleaseViewStatus.collectionItemEdited));
  }

  Future<void> _deleteCollectionItem(
    DeleteCollectionItem event,
    Emitter<ReleaseViewState> emit,
  ) async {
    await collectionItemService.delete(event.collectionItemId);
    emit(state.copyWith(status: ReleaseViewStatus.collectionItemDeleted));
  }
}
