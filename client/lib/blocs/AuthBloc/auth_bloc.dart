import 'package:bloc/bloc.dart';
import 'package:counter_x/presentation/ui/auth/login.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested> (_onLoginRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<LogoutRequested>(_onLogoutRrequested);
    on<CheckStatus>(_onCheckAuth);
  
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async{
    try{
       UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: event.email,
      password: event.password
    );
    emit(AuthSuccess(userCredential.user));
  }
on FirebaseAuthException catch(e){
  if(e.code == 'user-not-found'){
    emit(AuthFailure("No user found with this mail"));
  }
  else if (e.code == 'wrong-password'){
    emit(AuthFailure("Your password is wrong"));
  }
  else{
    emit(AuthFailure('Auth error'));
  }
}
    }

    Future<void> _onSignUpRequested(SignUpRequested event, Emitter<AuthState> emit) async{
      try{
        UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: event.email,
          password: event.password);
      } on FirebaseAuthException catch(e){
        emit(AuthFailure('SignUp error'));
      }
    }

    Future<void> _onLogoutRrequested(LogoutRequested event, Emitter<AuthState> emit) async{
      try{
        await _firebaseAuth.signOut();
        emit(AuthInitial());
      }
      catch(e){
        print(e);
      }
    }

    Future<void> _onCheckAuth(CheckStatus event, Emitter<AuthState> emit) async {
      final user =_firebaseAuth.currentUser;
      if(user != null){
        emit(AuthSuccess(user));
      }
      else{
        emit(AuthInitial());
      }
    }
   
  
  }
