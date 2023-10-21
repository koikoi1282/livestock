part of 'authentication_bloc.dart';

@immutable
sealed class AuthenticationEvent extends Equatable {}

class AutoLoginEvent extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}

class AutoLogoutEvent extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}

class LogInEvent extends AuthenticationEvent {
  final String emailAddress;
  final String password;

  LogInEvent({required this.emailAddress, required this.password});

  @override
  List<Object> get props => [emailAddress, password];
}
