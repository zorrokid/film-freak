import 'package:film_freak/screens/add_or_edit_release/view/add_or_edit_release_page.dart';
import 'package:film_freak/services/collection_item_service.dart';
import 'package:film_freak/services/release_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../persistence/query_specs/release_query_specs.dart';
import '../../add_or_edit_collection_item/collection_item_form.dart';
import '../../add_or_edit_release/view/release_form.dart';
import '../../view_release/view/release_page.dart';
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
      return AddOrEditReleasePage(
        barcode: barcode,
      );
    });

    await Navigator.push(context, route);
  }

  Future<void> createCollectionItem(BuildContext context, int releaseId) async {
    await Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return CollectionItemForm(
          releaseId: releaseId,
          releaseService: initializeReleaseService(),
          collectionItemService: initializeCollectionItemService(),
        );
      },
    ));
  }

  Future<void> delete(int releaseId, String barcode) async {
    // TODO
    /* final isOkToDelete = await okToDelete(context, 'Are you sure?',
        '''Are you really sure you want to delete the release? 
        Also the collection items created from this release 
        will be deleted!''');*/

    await releaseService.delete(releaseId);
    await getReleases(barcode);
  }

  Future<void> edit(BuildContext context, int releaseId, String barcode) async {
    await Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return AddOrEditReleasePage(
          id: releaseId,
          barcode: barcode,
        );
      },
    ));

    await getReleases(barcode);
  }

  Future<void> view(BuildContext context, int releaseId) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ReleasePage(releaseId: releaseId);
        },
      ),
    );
  }
}
