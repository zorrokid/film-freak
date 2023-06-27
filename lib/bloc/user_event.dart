import 'package:equatable/equatable.dart';

import '../api-models/token_model.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();
}

class LogInUser extends UserEvent {
  const LogInUser({
    required this.token,
  });
  final TokenModel token;

  @override
  List<Object?> get props => [token];
}

class LogOutUser extends UserEvent {
  const LogOutUser();
  @override
  List<Object?> get props => [];
}
