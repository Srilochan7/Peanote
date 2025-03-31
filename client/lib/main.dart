
import 'package:counter_x/blocs/AuthBloc/auth_bloc.dart';
import 'package:counter_x/main_screen.dart';
import 'package:counter_x/presentation/ui/home.dart';
import 'package:counter_x/presentation/ui/onboarding/on_board.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';



// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await dotenv.load(fileName: ".env");

// await Firebase.initializeApp(
//   options: FirebaseOptions(
//     apiKey: dotenv.env['FIREBASE_API_KEY']!,
//     appId: dotenv.env['FIREBASE_APP_ID']!,
//     projectId: dotenv.env['FIREBASE_PROJECT_ID']!,
//     messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID']!,
//     storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET']!,
//   ),
// );

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}




//   runApp(MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => AuthBloc(),),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Onboard(),
      ),
    );
  }
}

