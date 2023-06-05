import 'package:camera/camera.dart';
import 'package:film_freak/persistence/repositories/system_info_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../infrastructure/filesystem_service.dart';
import '../persistence/db_provider.dart';
import 'app_event.dart';
import 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({required this.systemInfoRepository}) : super(const AppState()) {
    on<GetSqliteVersion>(_onGetSqliteVersion);
    on<GetReleaseCount>(_onGetReleaseCount);
    on<GetCollectionItemCount>(_onGetCollectionItemCount);
    on<GetSaveDirectory>(_onGetSaveDirectory);
    on<GetFileCount>(_onGetFileCount);
    on<ResetDb>(_onResetDb);
    on<InitAppState>(_onInitAppState);
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

  Future<void> _onGetSaveDirectory(
      GetSaveDirectory event, Emitter<AppState> emit) async {
    final saveDirectory = await FilesystemService.releasePicsDir;
    emit(state.copyWith(
      saveDirectory: saveDirectory,
    ));
  }

  Future<void> _onGetFileCount(
      GetFileCount event, Emitter<AppState> emit) async {
    final saveDirectory = await FilesystemService.releasePicsDir;
    final fileCount = saveDirectory.listSync(recursive: true).length;
    emit(state.copyWith(
      fileCount: fileCount,
    ));
  }

  Future<void> _onResetDb(ResetDb event, Emitter<AppState> emit) async {
    emit(state.copyWith(
      status: AppStatus.dbResetStart,
    ));
    await DatabaseProviderSqflite.instance.truncateDb();
    // trigger initialize by calling database getter
    await DatabaseProviderSqflite.instance.database;
    emit(state.copyWith(
      status: AppStatus.initialized,
    ));
  }

  Future<void> _onInitAppState(
      InitAppState event, Emitter<AppState> emit) async {
    emit(state.copyWith(
      status: AppStatus.initializing,
    ));
    final cameras = await availableCameras();
    final saveDir = await FilesystemService.releasePicsDir;
    final thumbnailDir = await FilesystemService.releasePicsThumbnailDir;
    emit(
      state.copyWith(
        status: AppStatus.initialized,
        cameras: cameras,
        saveDirectory: saveDir,
        thumbnailDirectory: thumbnailDir,
      ),
    );
  }
}
