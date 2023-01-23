import 'package:film_freak/services/collection_item_service.dart';
import 'package:film_freak/services/release_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../persistence/query_specs/release_query_specs.dart';
import '../../add_or_edit_release/release_form.dart';
import '../view/barcode_scanner_view.dart';
import 'barcode_scan_state.dart';

class ScanBarcodeCubit extends Cubit<ScanBarcodeState> {
  ScanBarcodeCubit({
    required this.releaseService,
    required this.collectionItemService,
  }) : super(const ScanBarcodeState.initial());

  final ReleaseService releaseService;
  final CollectionItemService collectionItemService;

  Future<void> scanBarcode(BuildContext context) async {
    emit(const ScanBarcodeState.scanning());
    final barcode = await Navigator.push<String>(context,
        MaterialPageRoute<String>(builder: (context) {
      return const BarcodeScannerView();
    }));

    if (barcode == null) {
      emit(const ScanBarcodeState.initial());
    } else {
      final barcodeExists = await releaseService.barcodeExists(barcode);
      emit(ScanBarcodeState.scanned(barcode, barcodeExists));
    }
  }

  Future<void> getReleases(String barcode) async {
    emit(const ScanBarcodeState.loading());
    final releases = (await releaseService.getListModels(
            filter: ReleaseQuerySpecs(barcode: barcode)))
        .toList();
    emit(ScanBarcodeState.loaded(releases));
  }

  Future<void> addRelease(String barcode, BuildContext context) async {
    final route = MaterialPageRoute<String>(builder: (context) {
      return ReleaseForm(
        barcode: barcode,
        releaseService: releaseService,
      );
    });

    await Navigator.push(context, route);
  }
}
