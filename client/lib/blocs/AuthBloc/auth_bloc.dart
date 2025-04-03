import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:counter_x/services/UserServices/userService.dart';
import 'package:counter_x/services/firebase_auth/Auth_services.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService = AuthService(); // Instance of AuthService

  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckStatus>(_onCheckAuth);
  }

  // Handle LoginRequested event
  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading()); // Show loading state

    try {
      // Call the userLogin method from AuthService
      final user = await _authService.userLogin(email: event.email, password: event.password);

      // If login is successful, emit the AuthSuccess state with the current user
      emit(AuthSuccess(user));
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(e.message ?? "Login failed")); // Emit failure with Firebase error message
    } catch (e) {
      emit(AuthFailure(e.toString())); // Emit failure state if login fails
    }
  }

  // Handle SignUpRequested event
  Future<void> _onSignUpRequested(SignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading()); // Show loading state

    try {
      // Call the userSignUp method from AuthService
      final user = await _authService.userSignUp(email: event.email, password: event.password);

      // If signup is successful, emit the AuthSuccess state with the current user
      emit(AuthSuccess(user));
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase Auth errors
      emit(AuthFailure(e.message ?? "Sign up failed")); // Emit failure with Firebase error message
    } catch (e) {
      emit(AuthFailure(e.toString())); // Emit failure state if signup fails
    }
  }

  // Handle LogoutRequested event
  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    try {
      log( "Logout requested");
      await FirebaseAuth.instance.signOut();
      UserServices.deleteUser();
      emit(AuthInitial()); // Reset to initial state after successful logout
    } catch (e) {
      emit(AuthFailure("Logout failed: ${e.toString()}")); // Emit failure state if logout fails
    }
  }

  // Handle CheckStatus event (to check if user is logged in)
  Future<void> _onCheckAuth(CheckStatus event, Emitter<AuthState> emit) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      emit(AuthSuccess(user)); // If user is logged in, emit AuthSuccess
    } else {
      emit(AuthInitial()); // If no user is logged in, reset to AuthInitial state
    }
  }
}