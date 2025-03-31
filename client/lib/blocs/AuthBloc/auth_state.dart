part of 'auth_bloc.dart';

sealed class AuthState {
  const AuthState();
  
  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthSuccess extends AuthState{
  final User? user;

  AuthSuccess(this.user);
}

final class AuthFailure extends AuthState{
  final String message;

  AuthFailure(this.message);
  
}

final class AuthLoading extends AuthState{}
