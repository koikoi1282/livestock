import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livestock/repository/authentication_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository _authenticationRepository;

  AuthenticationBloc(this._authenticationRepository)
      : super(AuthenticationInitial()) {
    on<AuthenticationEvent>((event, emit) async {
      if (event is AutoLoginEvent) {
        emit(LoginState());
      } else if (event is AutoLogoutEvent) {
        emit(LogoutState());
      } else if (event is LogInEvent) {
        final String? message = await _authenticationRepository.login(
            event.emailAddress, event.password);
        if (message != null) {
          emit(AuthenticationErrorState(message: message));
          emit(LogoutState());
        }
      }
    });

    _authenticationRepository.userStream.listen((user) {
      if (user != null) {
        add(AutoLoginEvent());
      } else {
        add(AutoLogoutEvent());
      }
    });
  }
}
