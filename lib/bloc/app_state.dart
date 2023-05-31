import 'dart:io';

import 'package:equatable/equatable.dart';

enum AppStatus {
  initial,
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
    this.status = AppStatus.initial,
  });
  final String sqliteVersion;
  final int collectionItemCount;
  final int releaseCount;
  final Directory? saveDirectory;
  final int fileCount;
  final AppStatus status;

  AppState copyWith({
    String? sqliteVersion,
    int? collectionItemCount,
    int? releaseCount,
    Directory? saveDirectory,
    int? fileCount,
    AppStatus? status,
  }) =>
      AppState(
        sqliteVersion: sqliteVersion ?? this.sqliteVersion,
        collectionItemCount: collectionItemCount ?? this.collectionItemCount,
        releaseCount: releaseCount ?? this.releaseCount,
        saveDirectory: saveDirectory ?? this.saveDirectory,
        fileCount: fileCount ?? this.fileCount,
        status: status ?? this.status,
      );
  @override
  List<Object?> get props => [
        sqliteVersion,
        collectionItemCount,
        releaseCount,
        saveDirectory,
        fileCount,
        status
      ];
}
