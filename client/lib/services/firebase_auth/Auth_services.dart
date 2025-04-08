import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counter_x/models/UserModels/UserModel.dart';
import 'package:counter_x/services/FirestoreServices/firestore_service.dart';
import 'package:counter_x/services/UserServices/userService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

class AuthService {
  // Sign up method
  Future<User?> userSignUp({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final uid = userCredential.user!.uid;
      
      // Create user document in Firestore
      final userModel = UserModel(
        id: uid,
        name: email.split('@')[0],
        email: email,
        profilePic: "",
        subscription: false,
        createdAt: DateTime.now(),
        notes: [],
      );

      await FirestoreService().addUser(userModel);
      
      // Save user locally
      await UserServices.saveUser(uid);
      UserServices.addUser(uid);

      Fluttertoast.showToast(
        msg: "Sign Up Successful",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 14.sp,
      );

      return userCredential.user;
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
      
      throw FirebaseAuthException(
        code: e.code,
        message: message,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "An unexpected error occurred: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.sp,
      );
     
      throw Exception("An unexpected error occurred: $e");
    }
  }

  // Login method
  Future<User?> userLogin({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;

      // Check if user doc exists
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (!docSnapshot.exists) {
        // Create user document if it doesn't exist
        final userModel = UserModel(
          id: uid,
          name: email.split('@')[0],
          email: email,
          profilePic: "",
          subscription: false,
          createdAt: DateTime.now(),
          notes: [],
        );

        await FirestoreService().addUser(userModel);
      }

      // Save user locally
      await UserServices.saveUser(uid);
       UserServices.addUser(uid);

      Fluttertoast.showToast(
        msg: "Login Successful",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 14.sp,
      );

      return userCredential.user;
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
     
      throw FirebaseAuthException(
        code: e.code,
        message: message,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "An unexpected error occurred: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.sp,
      );
      
      throw Exception("An unexpected error occurred: $e");
    }
  }
}