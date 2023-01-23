import 'package:equatable/equatable.dart';

import '../../../models/list_models/release_list_model.dart';

enum ScanBarcodeStatus {
  initial,
  scanning,
  scanned,
  loading,
  loaded,
  success,
  failure,
}

class ScanBarcodeState extends Equatable {
  const ScanBarcodeState._({
    this.status = ScanBarcodeStatus.initial,
    this.items = const <ReleaseListModel>[],
    this.barcode = "",
    this.barcodeExists = false,
  });

  const ScanBarcodeState.initial() : this._();
  const ScanBarcodeState.scanning()
      : this._(status: ScanBarcodeStatus.scanning);
  const ScanBarcodeState.scanned(String barcode, bool exists)
      : this._(
          status: ScanBarcodeStatus.scanned,
          barcode: barcode,
          barcodeExists: exists,
        );
  const ScanBarcodeState.loading() : this._(status: ScanBarcodeStatus.loading);
  const ScanBarcodeState.loaded(List<ReleaseListModel> items)
      : this._(
          status: ScanBarcodeStatus.loaded,
          items: items,
        );
  const ScanBarcodeState.failure() : this._(status: ScanBarcodeStatus.failure);

  final ScanBarcodeStatus status;
  final List<ReleaseListModel> items;
  final String barcode;
  final bool barcodeExists;

  @override
  List<Object?> get props => [status, items];
}
