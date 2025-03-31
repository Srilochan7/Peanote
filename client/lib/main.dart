import 'package:counter_x/blocs/AuthBloc/auth_bloc.dart';
import 'package:counter_x/presentation/ui/onboarding/on_board.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),  // Initialize before MaterialApp
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple, // Optional: Set a theme
        ),
        home: Onboard(), // Ensure Onboard() is a valid widget
      ),
    );
  }
}
