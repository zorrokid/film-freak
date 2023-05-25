import 'package:equatable/equatable.dart';

class AppState extends Equatable {
  const AppState({
    this.sqliteVersion = "",
    this.collectionItemCount = 0,
    this.releaseCount = 0,
  });
  final String sqliteVersion;
  final int collectionItemCount;
  final int releaseCount;

  AppState copyWith({
    String? sqliteVersion,
    int? collectionItemCount,
    int? releaseCount,
  }) =>
      AppState(
        sqliteVersion: sqliteVersion ?? this.sqliteVersion,
        collectionItemCount: collectionItemCount ?? this.collectionItemCount,
        releaseCount: releaseCount ?? this.releaseCount,
      );
  @override
  List<Object?> get props => [
        sqliteVersion,
        collectionItemCount,
        releaseCount,
      ];
}
