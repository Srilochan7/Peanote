
import 'package:counter_x/blocs/AuthBloc/auth_bloc.dart';
import 'package:counter_x/main_screen.dart';
import 'package:counter_x/presentation/ui/home.dart';
import 'package:counter_x/presentation/ui/onboarding/on_board.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider <AuthBloc>(create: (context) => AuthBloc(),),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Onboard(),
      ),
    );
  }
}

