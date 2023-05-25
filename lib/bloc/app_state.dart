import 'package:equatable/equatable.dart';

class AppState extends Equatable {
  const AppState({
    this.sqliteVersion = "",
  });
  final String sqliteVersion;

  AppState copyWith({
    String? sqliteVersion,
  }) =>
      AppState(
        sqliteVersion: sqliteVersion ?? this.sqliteVersion,
      );
  @override
  List<Object?> get props => [
        sqliteVersion,
      ];
}
