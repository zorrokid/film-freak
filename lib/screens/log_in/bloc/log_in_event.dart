import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

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

class UserAdded extends LogInEvent {
  const UserAdded(this.context);
  final BuildContext context;
  @override
  List<Object> get props => [context];
}
