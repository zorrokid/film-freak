import 'package:equatable/equatable.dart';

enum UserStatus {
  loggedOut,
  loggedIn,
}

class UserState extends Equatable {
  const UserState({
    this.status = UserStatus.loggedOut,
    this.token = "",
    this.refreshToken = "",
    this.expirationTime,
  });
  final UserStatus status;
  final String token;
  final String refreshToken;
  final DateTime? expirationTime;

  UserState copyWith({
    UserStatus? status,
    String? token,
    String? refreshToken,
    DateTime? expirationTime,
  }) =>
      UserState(
        status: status ?? this.status,
        token: token ?? this.token,
        refreshToken: refreshToken ?? this.refreshToken,
        expirationTime: expirationTime ?? this.expirationTime,
      );
  @override
  List<Object?> get props => [
        status,
        token,
        refreshToken,
        expirationTime,
      ];
}
