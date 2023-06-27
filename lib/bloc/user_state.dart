import 'package:equatable/equatable.dart';

import '../api-models/token_model.dart';

enum UserStatus {
  loggedOut,
  loggedIn,
}

class UserState extends Equatable {
  const UserState({
    this.status = UserStatus.loggedOut,
    this.token,
  });
  final UserStatus status;
  final TokenModel? token;

  UserState copyWith({
    UserStatus? status,
    TokenModel? token,
  }) =>
      UserState(
        status: status ?? this.status,
        token: token ?? this.token,
      );
  @override
  List<Object?> get props => [
        status,
        token,
      ];
}
