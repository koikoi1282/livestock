part of 'authentication_bloc.dart';

@immutable
sealed class AuthenticationState extends Equatable {}

final class AuthenticationInitial extends AuthenticationState {
  @override
  List<Object> get props => [];
}

final class LoginState extends AuthenticationState {
  @override
  List<Object> get props => [];
}

final class LogoutState extends AuthenticationState {
  @override
  List<Object?> get props => [];
}

final class AuthenticationErrorState extends AuthenticationState {
  final String message;

  AuthenticationErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
