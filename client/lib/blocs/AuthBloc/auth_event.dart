part of 'auth_bloc.dart';

sealed class AuthEvent {
  const AuthEvent();

  @override
  List<Object> get props => [];
}


final class LoginRequested extends AuthEvent{
  final String email;
  final String password;

  LoginRequested(this.email, this.password);
}

final class SignUpRequested extends AuthEvent{
  final String email;
  final String password;


  SignUpRequested(this.email, this.password);
  }

  final class LogoutRequested extends AuthEvent{

  }

  final class CheckStatus extends AuthEvent{}