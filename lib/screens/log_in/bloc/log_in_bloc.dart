import 'package:film_freak/screens/releases/view/releases_page.dart';
import 'package:film_freak/screens/log_in/bloc/log_in_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/user_service.dart';
import 'log_in_state.dart';

class LogInBloc extends Bloc<LogInEvent, LogInState> {
  LogInBloc(this.userService) : super(const LogInState()) {
    on<SubmitLogin>(_onLogInSubmitted);
    on<UserAdded>(_onUserAdded);
  }

  final UserService userService;

  Future _onLogInSubmitted(SubmitLogin event, Emitter<LogInState> emit) async {
    emit(state.copyWith(
      status: LogInStatus.processing,
      username: event.username,
      password: event.password,
    ));
    try {
      final token =
          await userService.processLogin(event.username, event.password);
      if (token.token.isEmpty) throw Exception("Log in failed.");
      emit(state.copyWith(
        status: LogInStatus.loggedId,
        token: token,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: LogInStatus.failed,
        username: '',
        password: '',
        token: null,
      ));
    }
  }

  Future _onUserAdded(UserAdded event, Emitter<LogInState> emit) async {
    await Navigator.push(event.context, MaterialPageRoute(
      builder: (context) {
        return const ReleasesPage();
      },
    ));
  }
}
