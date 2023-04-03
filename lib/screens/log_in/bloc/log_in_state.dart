import 'package:equatable/equatable.dart';

enum LogInStatus { initial, processing, loggedId, failed }

class LogInState extends Equatable {
  const LogInState({
    this.status = LogInStatus.initial,
    this.username = "",
    this.password = "",
    this.token = "",
    this.refreshToken = "",
    this.expirationTime,
  });
  final LogInStatus status;
  final String username;
  final String password;
  final String token;
  final String refreshToken;
  final DateTime? expirationTime;

  LogInState copyWith({
    LogInStatus? status,
    String? username,
    String? password,
    String? token,
    String? refreshToken,
    DateTime? expirationTime,
  }) {
    return LogInState(
      status: status ?? this.status,
      username: username ?? this.username,
      password: password ?? this.password,
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
      expirationTime: expirationTime ?? this.expirationTime,
    );
  }

  @override
  List<Object?> get props => [
        status,
        username,
        password,
        refreshToken,
        token,
        expirationTime,
      ];
}
