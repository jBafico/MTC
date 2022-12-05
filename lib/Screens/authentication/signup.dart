import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maneja_tus_cuentas/Model/Category.dart';
import 'package:maneja_tus_cuentas/Screens/authentication/login.dart';
import 'package:maneja_tus_cuentas/Services/auth.dart';
import 'package:maneja_tus_cuentas/constants.dart';

import '../../Services/database.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

Future<bool> _onWillPop() async {
  return false;
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.20,
                    width: MediaQuery.of(context).size.width,
                  ),
                  SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            "Welcome!",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                          const SizedBox(height: defaultPadding * 2),
                          Row(
                            children: const [
                              Spacer(),
                              Expanded(
                                flex: 8,
                                child: SignUpForm(),
                              ),
                              Spacer(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  // Initially password is obscure
  bool _obscureText = true;

  String? errorMessage = '';

  final TextEditingController _controllerName = TextEditingController();

  final TextEditingController _controllerEmail = TextEditingController();

  final TextEditingController _controllerPassword = TextEditingController();

  final _auth = AuthService();

  final _users = FirebaseFirestore.instance.collection('users');

  Future<bool> registerInWithEmailAndPassword() async {
    try {
      await _auth.registerWithEmailAndPassword(_controllerEmail.text,
          _controllerPassword.text, _controllerName.text);

      final databaseService = DatabaseService(uid: _auth.currentUser!.uid);

      // Initialize user data
      databaseService.createUser(_controllerName.text);

      // Initialize default categories
      for (var category in Category.categories) {
        databaseService.updateCategory(category);
      }

      return true;
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });

      return false;
    }
  }

  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : '$errorMessage');
  }

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(4.0, 0, 0, 8.0),
            child: const Text(
              'Full Name',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
          TextField(
            controller: _controllerName,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            cursorColor: kPrimaryColor,
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(4.0, 16.0, 0, 8.0),
            child: const Text(
              'Email Address',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
          TextField(
            controller: _controllerEmail,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            cursorColor: kPrimaryColor,
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(4.0, 16.0, 0, 8.0),
            child: const Text(
              'Password',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
          TextField(
            controller: _controllerPassword,
            obscureText: _obscureText,
            cursorColor: kPrimaryColor,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                onPressed: _toggle,
                icon: const Icon(Icons.remove_red_eye_outlined),
              ),
            ),
          ),
          _errorMessage(),
          const SizedBox(height: defaultPadding),
          Hero(
            tag: "signup_btn",
            child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
                minimumSize: MaterialStateProperty.all(
                    Size(MediaQuery.of(context).size.width, 40)),
              ),
              onPressed: () async {
                await registerInWithEmailAndPassword().then((success) => {
                      if (success)
                        {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const RegisterConfirmation(),
                            ),
                          )
                        }
                    });
              },
              child: Text(
                "Sign Up".toUpperCase(),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const LoginScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;
  final Function? press;
  const AlreadyHaveAnAccountCheck({
    Key? key,
    this.login = false,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          login ? "Don’t have an Account ? " : "Already have an Account ? ",
          style: const TextStyle(color: Colors.black),
        ),
        GestureDetector(
          onTap: press as void Function()?,
          child: Text(
            login ? "Sign Up" : "Sign In",
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}

class RegisterConfirmation extends StatelessWidget {
  const RegisterConfirmation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mainTextStyle =
        const TextStyle(fontWeight: FontWeight.bold, fontSize: 24);
    var secondaryTextStyle = const TextStyle(fontSize: 14, color: Colors.grey);

    return Scaffold(
        backgroundColor: Colors.white,
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Container(
                        padding: const EdgeInsets.only(top: 100, bottom: 25),
                        /* postfix exclamation mark (!) takes the expression on the left and casts it to its underlying non-nullable type. So it changes:*/
                        child: Text("Cuenta creada",
                            textAlign: TextAlign.center, style: mainTextStyle)),
                    Container(
                      padding: const EdgeInsets.all(25),
                      child: Text(
                          "Tu cuenta fue creada con exito.\n Presiona continuar para seguir utilizando la app",
                          textAlign: TextAlign.center,
                          style: secondaryTextStyle),
                    ),
                    Container(
                        padding: const EdgeInsets.all(50),
                        child: Image.asset("assets/images/account_created.jpg",
                            fit: BoxFit.cover)),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: ElevatedButton(
                      onPressed: () => Navigator.of(context)
                          .popUntil((route) => route.isFirst),
                      // style: ButtonStyle(elevation: MaterialStateProperty(12.0 )),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                                (states) => Colors.green),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            )),
                      ),
                      child: const Text("Continuar")),
                ),
              ],
            );
          },
        ));
  }
}
