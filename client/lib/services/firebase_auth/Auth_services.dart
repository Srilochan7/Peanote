import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

class AuthService {
  // Sign up method
  Future<bool> userSignUp({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      Fluttertoast.showToast(
        msg: "Sign Up Successful",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 14.sp,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = "Your password is too weak";
      } else if (e.code == 'email-already-in-use') {
        message = "Your email is already in use";
      } else {
        message = "An error occurred: ${e.message}";
      }

      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.sp,
      );
      return false;
    } catch (e) {
      Fluttertoast.showToast(
        msg: "An unexpected error occurred: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.sp,
      );
      return false;
    }
  }

  // Login method
  Future<bool> userLogin({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      Fluttertoast.showToast(
        msg: "Login Successful",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 14.sp,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'wrong-password') {
        message = "Incorrect password";
      } else if (e.code == 'user-not-found') {
        message = "No user found with this email";
      } else {
        message = "An error occurred: ${e.message}";
      }

      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.sp,
      );
      return false;
    } catch (e) {
      Fluttertoast.showToast(
        msg: "An unexpected error occurred: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.sp,
      );
      return false;
    }
  }
}