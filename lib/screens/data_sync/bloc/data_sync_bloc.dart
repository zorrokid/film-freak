import 'package:film_freak/screens/data_sync/bloc/data_sync_event.dart';
import 'package:film_freak/screens/data_sync/bloc/data_sync_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../service/data_sync_service.dart';

class DataSyncBloc extends Bloc<DataSyncEvent, DataSyncState> {
  DataSyncBloc({required this.service}) : super(const DataSyncState()) {
    on<SynchronizeData>(_onSynchronizeData);
  }
  final DataSyncService service;

  void _onSynchronizeData(SynchronizeData event, Emitter<DataSyncState> emit) {
    emit(state.copyWith(
      status: DataSyncStatus.processing,
      batchSize: event.batchSize,
    ));

    emit(state.copyWith(
      status: DataSyncStatus.uploading,
    ));

    service.upload();

    // TODO

    // get total of release rows to be synchronized

    // set total to state

    // fetch data in batches

    // for each batch
    //  - update progress to state
    //  - save to database

    // set status to state
  }
}
