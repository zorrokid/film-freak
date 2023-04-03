import 'package:equatable/equatable.dart';

abstract class LogInEvent extends Equatable {
  const LogInEvent();
  @override
  List<Object> get props => [];
}

class SubmitLogin extends LogInEvent {
  const SubmitLogin(this.username, this.password);
  final String username;
  final String password;
  @override
  List<Object> get props => [username, password];
}
