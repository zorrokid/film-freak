import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/utils/dialog_utls.dart';
import '/services/release_service.dart';
import '../../add_or_edit_collection_item/view/add_or_edit_collection_item_page.dart';
import '../../add_or_edit_release/view/add_or_edit_release_page.dart';
import '../../view_release/view/release_page.dart';
import '../bloc/view_releases_state.dart';
import '../bloc/view_releases_event.dart';

class ViewReleasesBloc extends Bloc<ViewReleasesEvent, ViewReleasesState> {
  ViewReleasesBloc({required this.releaseService})
      : super(const ViewReleasesState()) {
    on<Initialize>(_onInitialize);
    on<GetReleases>(_onGetReleases);
    on<AddRelease>(_onAddRelease);
    on<EditRelease>(_onEditRelease);
    on<DeleteRelease>(_onDeleteRelease);
    on<ConfirmDelete>(_onConfirmDelete);
    on<ViewRelease>(_onViewRelease);
    on<CreateCollectionItem>(_onCreateCollectionItem);
  }
  final ReleaseService releaseService;

  void _onInitialize(
    Initialize event,
    Emitter<ViewReleasesState> emit,
  ) {
    emit(state.copyWith(
      status: ViewReleasesStatus.initialized,
      filter: event.filter,
    ));
  }

  Future<void> _onGetReleases(
    GetReleases event,
    Emitter<ViewReleasesState> emit,
  ) async {
    emit(state.copyWith(status: ViewReleasesStatus.loading));
    final releases = (await releaseService.getListModels()).toList();
    emit(state.copyWith(
      status: ViewReleasesStatus.loaded,
      items: releases,
    ));
  }

  Future<void> _onAddRelease(
    AddRelease event,
    Emitter<ViewReleasesState> emit,
  ) async {
    final route = MaterialPageRoute<String>(builder: (context) {
      return const AddOrEditReleasePage();
    });

    await Navigator.push(event.context, route);
    emit(state.copyWith(status: ViewReleasesStatus.releaseAdded));
  }

  Future<void> _onCreateCollectionItem(
    CreateCollectionItem event,
    Emitter<ViewReleasesState> emit,
  ) async {
    await Navigator.push(event.context, MaterialPageRoute(
      builder: (context) {
        return AddOrEditCollectionItemPage(releaseId: event.releaseId);
      },
    ));
    emit(state.copyWith(status: ViewReleasesStatus.collectionItemAdded));
  }

  Future<void> _onDeleteRelease(
    DeleteRelease event,
    Emitter<ViewReleasesState> emit,
  ) async {
    await releaseService.delete(event.releaseId);
    emit(state.copyWith(status: ViewReleasesStatus.releaseDeleted));
  }

  Future<void> _onConfirmDelete(
    ConfirmDelete event,
    Emitter<ViewReleasesState> emit,
  ) async {
    final canDelete = await confirm(event.context, 'Are you sure?',
        '''Are you really sure you want to delete the release? 
        Also the collection items created from this release 
        will be deleted!''');
    emit(state.copyWith(
      status: ViewReleasesStatus.deleteConfirmed,
      canDelete: canDelete,
      releaseId: event.releaseId,
    ));
  }

  Future<void> _onEditRelease(
    EditRelease event,
    Emitter<ViewReleasesState> emit,
  ) async {
    await Navigator.push(event.context, MaterialPageRoute(
      builder: (context) {
        return AddOrEditReleasePage(
          id: event.releaseId,
        );
      },
    ));
    emit(state.copyWith(status: ViewReleasesStatus.releaseEdited));
  }

  Future<void> _onViewRelease(
    ViewRelease event,
    Emitter<ViewReleasesState> emit,
  ) async {
    Navigator.push(
      event.context,
      MaterialPageRoute(
        builder: (context) {
          return ReleasePage(releaseId: event.releaseId);
        },
      ),
    );
  }
}
