import 'package:counter_x/blocs/AuthBloc/auth_bloc.dart';
import 'package:counter_x/hiveModels/UserHiveModel.dart';
import 'package:counter_x/presentation/ui/auth/signup.dart';
import 'package:counter_x/presentation/ui/onboarding/on_board.dart';
import 'package:counter_x/presentation/ui/onboarding/splashscreen.dart';
import 'package:counter_x/services/firebase_auth/Auth_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Firebase.initializeApp();
  Hive.registerAdapter(UserHiveModelAdapter());
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(UserHiveModelAdapter());
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Splashscreen(),
      ),
    );
  }
}
