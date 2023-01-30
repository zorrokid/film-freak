import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/collection_item_service.dart';
import '../../../services/release_service.dart';
import '../../../persistence/query_specs/release_query_specs.dart';
import '../../../utils/dialog_utls.dart';
import '../../add_or_edit_collection_item/collection_item_form.dart';
import '../../add_or_edit_release/view/add_or_edit_release_page.dart';
import '../../view_release/view/release_page.dart';
import '../view/barcode_scanner_view.dart';
import 'barcode_scan_event.dart';
import 'barcode_scan_state.dart';

class ScanBarcodeBloc extends Bloc<BarcodeScanEvent, BarcodeScanState> {
  ScanBarcodeBloc({
    required this.releaseService,
    required this.collectionItemService,
  }) : super(const BarcodeScanState()) {
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

  Future<void> _onScanBarcode(
    ScanBarcode event,
    Emitter<BarcodeScanState> emit,
  ) async {
    emit(state.copyWith(status: BarcodeScanStatus.scanning));
    final barcode = await Navigator.push<String>(event.context,
        MaterialPageRoute<String>(builder: (context) {
      return const BarcodeScannerView();
    }));

    if (barcode == null) {
      emit(state.copyWith(status: BarcodeScanStatus.initial));
    } else {
      final barcodeExists = await releaseService.barcodeExists(barcode);
      emit(
        state.copyWith(
          status: BarcodeScanStatus.scanned,
          barcodeExists: barcodeExists,
          barcode: barcode,
        ),
      );
    }
  }

  Future<void> _onGetReleases(
    GetReleases event,
    Emitter<BarcodeScanState> emit,
  ) async {
    emit(state.copyWith(status: BarcodeScanStatus.loading));
    final releases = (await releaseService.getListModels(
            filter: ReleaseQuerySpecs(barcode: event.barcode)))
        .toList();
    emit(state.copyWith(
      status: BarcodeScanStatus.loaded,
      items: releases,
    ));
  }

  Future<void> _onAddRelease(
    AddRelease event,
    Emitter<BarcodeScanState> emit,
  ) async {
    final route = MaterialPageRoute<String>(builder: (context) {
      return AddOrEditReleasePage(
        barcode: event.barcode,
      );
    });

    await Navigator.push(event.context, route);
    emit(state.copyWith(status: BarcodeScanStatus.releaseAdded));
  }

  Future<void> _onCreateCollectionItem(
    CreateCollectionItem event,
    Emitter<BarcodeScanState> emit,
  ) async {
    await Navigator.push(event.context, MaterialPageRoute(
      builder: (context) {
        return CollectionItemForm(
          releaseId: event.releaseId,
          releaseService: initializeReleaseService(),
          collectionItemService: initializeCollectionItemService(),
        );
      },
    ));
    emit(state.copyWith(status: BarcodeScanStatus.collectionItemAdded));
  }

  Future<void> _onDeleteRelease(
    DeleteRelease event,
    Emitter<BarcodeScanState> emit,
  ) async {
    await releaseService.delete(event.releaseId);
    emit(state.copyWith(status: BarcodeScanStatus.releaseDeleted));
  }

  Future<void> _onConfirmDelete(
    ConfirmDelete event,
    Emitter<BarcodeScanState> emit,
  ) async {
    final canDelete = await confirm(event.context, 'Are you sure?',
        '''Are you really sure you want to delete the release? 
        Also the collection items created from this release 
        will be deleted!''');
    emit(state.copyWith(
      status: BarcodeScanStatus.deleteConfirmed,
      canDelete: canDelete,
      releaseId: event.releaseId,
    ));
  }

  Future<void> _onEditRelease(
    EditRelease event,
    Emitter<BarcodeScanState> emit,
  ) async {
    await Navigator.push(event.context, MaterialPageRoute(
      builder: (context) {
        return AddOrEditReleasePage(
          id: event.releaseId,
        );
      },
    ));
    emit(state.copyWith(status: BarcodeScanStatus.releaseEdited));
  }

  Future<void> _onViewRelease(
    ViewRelease event,
    Emitter<BarcodeScanState> emit,
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
