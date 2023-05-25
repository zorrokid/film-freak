import 'package:equatable/equatable.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();
}

class GetSqliteVersion extends AppEvent {
  const GetSqliteVersion();

  @override
  List<Object?> get props => [];
}

class GetReleaseCount extends AppEvent {
  const GetReleaseCount();

  @override
  List<Object?> get props => [];
}

class GetCollectionItemCount extends AppEvent {
  const GetCollectionItemCount();

  @override
  List<Object?> get props => [];
}
