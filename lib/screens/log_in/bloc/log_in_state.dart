import 'package:equatable/equatable.dart';

enum LogInStatus { initial, processing, loggedId }

class LogInState extends Equatable {
  const LogInState({
    this.status = LogInStatus.initial,
    this.username = "",
    this.password = "",
    this.token = "",
  });
  final LogInStatus status;
  final String username;
  final String password;
  final String token;

  LogInState copyWith({
    LogInStatus? status,
    String? username,
    String? password,
    String? token,
  }) {
    return LogInState(
      status: status ?? this.status,
      username: username ?? this.username,
      password: password ?? this.password,
      token: token ?? this.token,
    );
  }

  @override
  List<Object?> get props => [
        username,
        password,
        token,
      ];
}
