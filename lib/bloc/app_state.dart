import 'dart:io';

import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';

enum AppStatus {
  initial,
  initializing,
  initialized,
  dbResetStart,
  dbResetDone,
}

class AppState extends Equatable {
  const AppState({
    this.sqliteVersion = "",
    this.collectionItemCount = 0,
    this.releaseCount = 0,
    this.fileCount = 0,
    this.saveDirectory,
    this.thumbnailDirectory,
    this.status = AppStatus.initial,
    this.cameras = const [],
  });
  final String sqliteVersion;
  final int collectionItemCount;
  final int releaseCount;
  final Directory? saveDirectory;
  final Directory? thumbnailDirectory;
  final int fileCount;
  final AppStatus status;
  final List<CameraDescription> cameras;

  AppState copyWith({
    String? sqliteVersion,
    int? collectionItemCount,
    int? releaseCount,
    Directory? saveDirectory,
    Directory? thumbnailDirectory,
    int? fileCount,
    AppStatus? status,
    List<CameraDescription>? cameras,
  }) =>
      AppState(
        sqliteVersion: sqliteVersion ?? this.sqliteVersion,
        collectionItemCount: collectionItemCount ?? this.collectionItemCount,
        releaseCount: releaseCount ?? this.releaseCount,
        saveDirectory: saveDirectory ?? this.saveDirectory,
        thumbnailDirectory: thumbnailDirectory ?? this.thumbnailDirectory,
        fileCount: fileCount ?? this.fileCount,
        status: status ?? this.status,
        cameras: cameras ?? this.cameras,
      );

  @override
  List<Object?> get props => [
        sqliteVersion,
        collectionItemCount,
        releaseCount,
        saveDirectory,
        thumbnailDirectory,
        fileCount,
        status,
        cameras,
      ];
}
