import 'package:equatable/equatable.dart';

import '../../../models/list_models/release_list_model.dart';

enum BarcodeScanStatus {
  initial,
  scanning,
  scanned,
  loading,
  loaded,
  success,
  failure,
  releaseAdded,
  collectionItemAdded,
  deleteConfirmed,
  releaseDeleted,
  releaseEdited,
}

class BarcodeScanState extends Equatable {
  const BarcodeScanState({
    this.status = BarcodeScanStatus.initial,
    this.items = const <ReleaseListModel>[],
    this.barcode = "",
    this.barcodeExists = false,
    this.error = "",
    this.releaseId,
    this.canDelete = false,
  });

  final BarcodeScanStatus status;
  final List<ReleaseListModel> items;
  final String barcode;
  final bool barcodeExists;
  final String error;
  final int? releaseId;
  final bool canDelete;

  BarcodeScanState copyWith({
    BarcodeScanStatus? status,
    List<ReleaseListModel>? items,
    String? barcode,
    bool? barcodeExists,
    String? error,
    int? releaseId,
    bool? canDelete,
  }) {
    return BarcodeScanState(
      status: status ?? this.status,
      items: items ?? this.items,
      barcode: barcode ?? this.barcode,
      barcodeExists: barcodeExists ?? this.barcodeExists,
      error: error ?? this.error,
      releaseId: releaseId ?? this.releaseId,
      canDelete: canDelete ?? this.canDelete,
    );
  }

  @override
  List<Object?> get props => [
        status,
        items,
        barcode,
        barcodeExists,
        error,
        releaseId,
      ];
}
