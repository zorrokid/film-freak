import 'package:equatable/equatable.dart';
import 'package:film_freak/persistence/query_specs/query_specs_enums.dart';

import '../../../models/list_models/release_list_model.dart';
import '../../../persistence/query_specs/release_query_specs.dart';

enum ReleasesStatus {
  initial,
  initialized,
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
  deleteFailed,
}

class ReleasesState extends Equatable {
  const ReleasesState({
    this.status = ReleasesStatus.initial,
    this.items = const <ReleaseListModel>[],
    this.barcode = "",
    this.barcodeExists = false,
    this.error = "",
    this.releaseId,
    this.querySpecs =
        const ReleaseQuerySpecs(top: 10, orderBy: OrderByEnum.latest),
  });

  final ReleasesStatus status;
  final List<ReleaseListModel> items;
  final String barcode;
  final bool barcodeExists;
  final String error;
  final int? releaseId;
  final ReleaseQuerySpecs querySpecs;

  ReleasesState copyWith({
    ReleasesStatus? status,
    List<ReleaseListModel>? items,
    String? barcode,
    bool? barcodeExists,
    String? error,
    int? releaseId,
    ReleaseQuerySpecs? querySpecs,
  }) {
    return ReleasesState(
      status: status ?? this.status,
      items: items ?? this.items,
      barcode: barcode ?? this.barcode,
      barcodeExists: barcodeExists ?? this.barcodeExists,
      error: error ?? this.error,
      releaseId: releaseId ?? this.releaseId,
      querySpecs: querySpecs ?? this.querySpecs,
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
