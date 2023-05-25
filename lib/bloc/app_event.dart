import 'package:equatable/equatable.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();
}

class GetSqliteVersion extends AppEvent {
  const GetSqliteVersion();

  @override
  List<Object?> get props => [];
}
