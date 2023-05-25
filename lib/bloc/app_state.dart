import 'dart:io';

import 'package:equatable/equatable.dart';

class AppState extends Equatable {
  const AppState({
    this.sqliteVersion = "",
    this.collectionItemCount = 0,
    this.releaseCount = 0,
    this.fileCount = 0,
    this.saveDirectory,
  });
  final String sqliteVersion;
  final int collectionItemCount;
  final int releaseCount;
  final Directory? saveDirectory;
  final int fileCount;

  AppState copyWith({
    String? sqliteVersion,
    int? collectionItemCount,
    int? releaseCount,
    Directory? saveDirectory,
    int? fileCount,
  }) =>
      AppState(
        sqliteVersion: sqliteVersion ?? this.sqliteVersion,
        collectionItemCount: collectionItemCount ?? this.collectionItemCount,
        releaseCount: releaseCount ?? this.releaseCount,
        saveDirectory: saveDirectory ?? this.saveDirectory,
        fileCount: fileCount ?? this.fileCount,
      );
  @override
  List<Object?> get props => [
        sqliteVersion,
        collectionItemCount,
        releaseCount,
        saveDirectory,
        fileCount,
      ];
}
