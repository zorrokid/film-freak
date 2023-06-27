import 'package:equatable/equatable.dart';

import '../model/import_item.dart';

enum DataSyncStatus {
  initial,
  processing,
  uploading,
  downloading,
  error,
  done,
}

const defaultBatchSize = 500;

class DataSyncState extends Equatable {
  const DataSyncState({
    this.status = DataSyncStatus.initial,
    this.batchSize = defaultBatchSize,
    this.totalItems = 0,
    this.importItems = const <ImportItem>[],
    this.error = "",
  });

  final DataSyncStatus status;
  final int batchSize;
  final int totalItems;
  final List<ImportItem> importItems;
  final String error;

  DataSyncState copyWith({
    DataSyncStatus? status,
    int? batchSize,
    int? totalItems,
    List<ImportItem>? importItems,
    String? error,
  }) =>
      DataSyncState(
        batchSize: batchSize ?? this.batchSize,
        importItems: importItems ?? this.importItems,
        status: status ?? this.status,
        totalItems: totalItems ?? this.totalItems,
        error: error ?? this.error,
      );

  @override
  List<Object?> get props => [
        status,
        batchSize,
        totalItems,
        importItems,
        error,
      ];
}
