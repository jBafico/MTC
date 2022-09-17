import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:maneja_tus_cuentas/Screens/authentication/login.dart';
import 'package:maneja_tus_cuentas/Screens/authentication/signup.dart';
import 'package:maneja_tus_cuentas/constants.dart';
import 'Screens/home/home.dart';
import 'firebase_options.dart';
import 'package:maneja_tus_cuentas/Services/auth.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MTC',
      theme: ThemeData(
        // This is the theme of your application.

        primarySwatch: kPrimaryColor,
      ),
      home: const WidgetTree(),
    );
  }
}

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {

  final _authChanges = AuthService().authStateChanges;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _authChanges,
      builder: (context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done) {
          return snapshot.hasData ? const HomePage() : const LoginScreen();
        }
        return const CircularProgressIndicator();
      },
    );
  }
}


