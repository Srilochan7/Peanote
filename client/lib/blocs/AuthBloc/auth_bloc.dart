import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:counter_x/presentation/ui/auth/login.dart';
import 'package:counter_x/services/firebase_auth/Auth_services.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<LogoutRequested>(_onLogoutRequested); // ✅ Fixed typo
    on<CheckStatus>(_onCheckAuth);
  }

  