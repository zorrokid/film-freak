import 'package:film_freak/persistence/repositories/system_info_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_event.dart';
import 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({required this.systemInfoRepository}) : super(const AppState()) {
    on<GetSqliteVersion>(_onGetSqliteVersion);
    on<GetReleaseCount>(_onGetReleaseCount);
    on<GetCollectionItemCount>(_onGetCollectionItemCount);
  }
  final SystemInfoRepository systemInfoRepository;

  Future<void> _onGetSqliteVersion(
      GetSqliteVersion event, Emitter<AppState> emit) async {
    final sqliteVersion = await systemInfoRepository.getSqliteVersion();
    emit(state.copyWith(
      sqliteVersion: sqliteVersion,
    ));
  }

  Future<void> _onGetReleaseCount(
      GetReleaseCount event, Emitter<AppState> emit) async {
    final releaseCount = await systemInfoRepository.getReleasesCount();
    emit(state.copyWith(
      releaseCount: releaseCount,
    ));
  }

  Future<void> _onGetCollectionItemCount(
      GetCollectionItemCount event, Emitter<AppState> emit) async {
    final collectionItemCount =
        await systemInfoRepository.getCollectionItemCount();
    emit(state.copyWith(
      collectionItemCount: collectionItemCount,
    ));
  }
}
