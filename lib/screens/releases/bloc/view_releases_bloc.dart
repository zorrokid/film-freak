import 'package:film_freak/persistence/query_specs/release_query_specs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/collection_item_service.dart';
import '../../../services/release_service.dart';
import '../../../utils/dialog_utls.dart';
import '../../add_or_edit_release/view/add_or_edit_release_page.dart';
import '../../add_or_edit_collection_item/view/add_or_edit_collection_item_page.dart';
import '../../view_release/view/release_page.dart';
import '../../scan_barcode/barcode_scanner_view.dart';
import 'view_releases_event.dart';
import 'view_releases_state.dart';

class ReleasesBloc extends Bloc<ReleasesEvent, ReleasesState> {
  ReleasesBloc({
    required this.releaseService,
    required this.collectionItemService,
  }) : super(const ReleasesState()) {
    on<Initialize>(_onInitialize);
    on<ScanBarcode>(_onScanBarcode);
    on<GetReleases>(_onGetReleases);
    on<AddRelease>(_onAddRelease);
    on<EditRelease>(_onEditRelease);
    on<DeleteRelease>(_onDeleteRelease);
    on<ConfirmDelete>(_onConfirmDelete);
    on<ViewRelease>(_onViewRelease);
    on<CreateCollectionItem>(_onCreateCollectionItem);
  }

  final ReleaseService releaseService;
  final CollectionItemService collectionItemService;

  void _onInitialize(
    Initialize event,
    Emitter<ReleasesState> emit,
  ) {
    emit(state.copyWith(
      status: ReleasesStatus.initialized,
      querySpecs: event.querySpecs,
    ));
  }

  Future<void> _onScanBarcode(
    ScanBarcode event,
    Emitter<ReleasesState> emit,
  ) async {
    emit(state.copyWith(status: ReleasesStatus.scanning));
    final barcode = await Navigator.push<String>(event.context,
        MaterialPageRoute<String>(builder: (context) {
      return const BarcodeScannerView();
    }));

    if (barcode == null) {
      emit(state.copyWith(status: ReleasesStatus.initial));
    } else {
      final barcodeExists = await releaseService.barcodeExists(barcode);
      emit(
        state.copyWith(
          status: ReleasesStatus.scanned,
          barcodeExists: barcodeExists,
          barcode: barcode,
        ),
      );
    }
  }

  Future<void> _onGetReleases(
    GetReleases event,
    Emitter<ReleasesState> emit,
  ) async {
    emit(state.copyWith(
      status: ReleasesStatus.loading,
      querySpecs: event.querySpecs,
    ));
    final releases =
        (await releaseService.getListModels(filter: event.querySpecs)).toList();
    emit(state.copyWith(
      status: ReleasesStatus.loaded,
      items: releases,
    ));
  }

  Future<void> _onAddRelease(
    AddRelease event,
    Emitter<ReleasesState> emit,
  ) async {
    final route = MaterialPageRoute<int>(builder: (context) {
      return AddOrEditReleasePage(
        barcode: event.barcode,
      );
    });

    final releaseId = await Navigator.push(event.context, route);

    if (releaseId == null) {
      emit(state.copyWith(
        status: ReleasesStatus.failure,
        error: 'Adding release failed',
      ));
      return;
    }

    emit(state.copyWith(
        status: ReleasesStatus.releaseAdded, releaseId: releaseId));
  }

  Future<void> _onCreateCollectionItem(
    CreateCollectionItem event,
    Emitter<ReleasesState> emit,
  ) async {
    await Navigator.push(event.context, MaterialPageRoute(
      builder: (context) {
        return AddOrEditCollectionItemPage(releaseId: event.releaseId);
      },
    ));
    emit(state.copyWith(status: ReleasesStatus.collectionItemAdded));
  }

  Future<void> _onDeleteRelease(
    DeleteRelease event,
    Emitter<ReleasesState> emit,
  ) async {
    final deleted = await releaseService.delete(event.releaseId);
    if (deleted > 0) {
      emit(state.copyWith(status: ReleasesStatus.releaseDeleted));
    } else {
      emit(state.copyWith(status: ReleasesStatus.deleteFailed));
    }
  }

  Future<void> _onConfirmDelete(
    ConfirmDelete event,
    Emitter<ReleasesState> emit,
  ) async {
    final canDelete = await confirm(
      context: event.context,
      title: 'Are you sure?',
      message: '''Are you really sure you want to delete the release? 
        Also the collection items created from this release 
        will be deleted!''',
    );
    if (!canDelete) return;
    emit(state.copyWith(
      status: ReleasesStatus.deleteConfirmed,
      releaseId: event.releaseId,
    ));
  }

  Future<void> _onEditRelease(
    EditRelease event,
    Emitter<ReleasesState> emit,
  ) async {
    await Navigator.push(event.context, MaterialPageRoute(
      builder: (context) {
        return AddOrEditReleasePage(
          id: event.releaseId,
        );
      },
    ));

    // reload and replace the edited release
    final querySpecs = ReleaseQuerySpecs(
      ids: [event.releaseId],
    );
    final release = await releaseService.getListModels(filter: querySpecs);
    final releaseInList = state.items.singleWhere(
      (element) => element.id == event.releaseId,
    );
    final index = state.items.indexOf(releaseInList);
    final releases = [...state.items];
    releases[index] = release.single;

    emit(state.copyWith(
      status: ReleasesStatus.loaded,
      items: releases,
    ));
  }

  Future<void> _onViewRelease(
    ViewRelease event,
    Emitter<ReleasesState> emit,
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
