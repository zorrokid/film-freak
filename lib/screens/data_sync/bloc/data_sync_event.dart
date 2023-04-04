import 'package:equatable/equatable.dart';

abstract class DataSyncEvent extends Equatable {
  const DataSyncEvent();
}

class SynchronizeData extends DataSyncEvent {
  const SynchronizeData({required this.batchSize});
  final int batchSize;
  @override
  List<Object?> get props => [batchSize];
}
