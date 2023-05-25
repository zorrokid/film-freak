import 'package:film_freak/persistence/repositories/system_info_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_event.dart';
import 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({required this.systemInfoRepository}) : super(const AppState()) {
    on<GetSqliteVersion>(_onGetSqliteVersion);
  }
  final SystemInfoRepository systemInfoRepository;

  Future<void> _onGetSqliteVersion(
      GetSqliteVersion event, Emitter<AppState> emit) async {
    final sqliteVersion = await systemInfoRepository.getSqliteVersion();
    emit(state.copyWith(
      sqliteVersion: sqliteVersion,
    ));
  }
}
