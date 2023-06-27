import 'package:film_freak/bloc/user_event.dart';
import 'package:film_freak/bloc/user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(const UserState()) {
    on<LogInUser>(_onLogInUser);
    on<LogOutUser>(_onLogOutUser);
  }

  void _onLogInUser(LogInUser event, Emitter<UserState> emit) {
    emit(state.copyWith(
      status: UserStatus.loggedIn,
      token: event.token,
    ));
  }

  void _onLogOutUser(LogOutUser event, Emitter<UserState> emit) {
    emit(state.copyWith(
      status: UserStatus.loggedOut,
      token: null,
    ));
  }
}
