import 'package:film_freak/screens/log_in/bloc/log_in_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/user_service.dart';
import 'log_in_state.dart';

class LogInBloc extends Bloc<LogInEvent, LogInState> {
  LogInBloc(this.userService) : super(const LogInState()) {
    on<SubmitLogin>(_onLogInSubmitted);
  }

  final UserService userService;

  Future _onLogInSubmitted(SubmitLogin event, Emitter<LogInState> emit) async {
    emit(state.copyWith(
      status: LogInStatus.processing,
      username: event.username,
      password: event.password,
    ));
    try {
      final response =
          await userService.processLogin(event.username, event.password);
      emit(state.copyWith(
        status: LogInStatus.loggedId,
        token: response.token,
        expirationTime: response.expiration,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: LogInStatus.failed,
        username: '',
        password: '',
        expirationTime: null,
        token: '',
      ));
    }
  }
}
