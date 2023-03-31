import 'package:film_freak/screens/log_in/bloc/log_in_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'log_in_state.dart';

class LogInBloc extends Bloc<LogInEvent, LogInState> {
  LogInBloc() : super(const LogInState()) {
    on<LogInSubmitted>(_onLogInSubmitted);
  }

  void _onLogInSubmitted(LogInSubmitted event, Emitter<LogInState> emit) {
    emit(state.copyWith(username: event.username, password: event.password));
  }
}
