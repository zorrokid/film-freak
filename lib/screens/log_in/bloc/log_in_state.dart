import 'package:equatable/equatable.dart';

import '../../../api-models/token_model.dart';

enum LogInStatus { initial, processing, loggedId, failed }

class LogInState extends Equatable {
  const LogInState({
    this.status = LogInStatus.initial,
    this.username = "",
    this.password = "",
    this.token,
  });
  final LogInStatus status;
  final String username;
  final String password;
  final TokenModel? token;

  LogInState copyWith({
    LogInStatus? status,
    String? username,
    String? password,
    String? refreshToken,
    DateTime? expirationTime,
    TokenModel? token,
  }) {
    return LogInState(
      status: status ?? this.status,
      username: username ?? this.username,
      password: password ?? this.password,
      token: token ?? this.token,
    );
  }

  @override
  List<Object?> get props => [status, username, password, token];
}
