import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();
}

class LogInUser extends UserEvent {
  const LogInUser({
    required this.token,
    required this.refreshToken,
    required this.expirationTime,
  });
  final String token;
  final String refreshToken;
  final DateTime expirationTime;

  @override
  List<Object?> get props => [
        token,
        refreshToken,
        expirationTime,
      ];
}

class LogOutUser extends UserEvent {
  const LogOutUser();
  @override
  List<Object?> get props => [];
}
