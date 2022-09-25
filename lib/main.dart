import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:maneja_tus_cuentas/Screens/authentication/login.dart';
import 'package:maneja_tus_cuentas/constants.dart';
import 'Screens/home/home.dart';
import 'firebase_options.dart';
import 'package:maneja_tus_cuentas/Services/auth.dart';
import 'Screens/intro/intros.dart';

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
      initialRoute: '/',
      home: const WidgetTree(),
      routes: {
        "/intro1" : (context) => const Intros(image: "intro1.jpg", buttonColor: Colors.green,buttonMessage: "Siguiente paso",mainMessage: "Ingresa tus gastos!", auxMessage: "Lleva registro de tus gastos asi estas\ninformado siempre de tu situacion actual.", buttonMessageColor: Colors.white, nextButtonRoute: "/intro2"),
        "/intro2" : (context) => const Intros(image: "intro2.jpg", buttonColor: Colors.green,buttonMessage: "Siguiente paso",mainMessage: "¡Genera ganancias!", auxMessage: "¡Defini tu presupuesto y alcanza tu metas!", buttonMessageColor: Colors.white,nextButtonRoute: "/intro3"),
        "/intro3" : (context) => const Intros(image: "intro3.jpg", buttonColor: Colors.green, buttonMessage: "Ingresa ahora!", mainMessage: "Facil de usar", auxMessage: "una manera sencilla y\nrapida de organizar gastos", buttonMessageColor: Colors.white, nextButtonRoute: "/intro1")
      },
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


