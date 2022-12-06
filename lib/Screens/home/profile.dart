import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maneja_tus_cuentas/Screens/change_password.dart';
import 'package:maneja_tus_cuentas/Services/auth.dart';
import 'package:maneja_tus_cuentas/constants.dart';

import '../../Model/UserData.dart';
import '../../Services/database.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _balanceController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String _message = "";

  final DatabaseService _databaseService =
      DatabaseService(uid: AuthService().currentUser!.uid);

  final AuthService _auth = AuthService();

  @override
  initState() {
    super.initState();

    _emailController.text = _auth.currentUser!.email!;
  }

  Future _updateUserData() async {

    if (_nameController.text.isEmpty ||
        _balanceController.text.isEmpty ||
        _emailController.text.isEmpty) {
      _message = "Por favor, rellene todos los campos";
      return;
    }

    try {
      double balance = double.parse(_balanceController.text);


      UserData dbData = await _databaseService.getUserData();
      String dbEmail = _auth.currentUser!.email!;

      if (dbData.name == _nameController.text &&
          dbData.balance == balance &&
          dbEmail == _emailController.text) {
        _message = "No se han realizado cambios";
        return;
      }

      if (_nameController.text != dbData.name) {
        await _databaseService.updateUserName(_nameController.text);
      }

      if (balance != dbData.balance) {
        await _databaseService.updateUserBalance(balance);
      }

      if (_emailController.text != dbEmail) {
        await _auth.updateEmail(_emailController.text);
      }

      await _auth.updateEmail(_emailController.text);

      _message = 'Perfil actualizado';
    } on FormatException {
      _message = 'Ingrese un número válido';
    } on FirebaseAuthException {
      _message = "El correo electrónico ya está en uso o es inválido";
    } on Exception {
      _message = 'Error al actualizar el perfil';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Editar Perfil',
              style: TextStyle(
                fontSize: 30,
              ),
            ),
          ),

          // Nombre
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Nombre',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Field to change name
          StreamBuilder<UserData>(
              stream: _databaseService.userData,
              builder: (context, snapshot) {
                _nameController.text = snapshot.data?.name ?? '';

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _nameController,
                  ),
                );
              }),

          // Balance
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Balance',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Field to change balance
          StreamBuilder<UserData>(
              stream: _databaseService.userData,
              builder: (context, snapshot) {
                _balanceController.text = snapshot.data?.balance.toStringAsFixed(2) ?? '';

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _balanceController,
                    keyboardType: TextInputType.number,
                  ),
                );
              }),

          // Correo electrónico
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Correo electrónico',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),

          // Field to change email
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _emailController,
            ),
          ),

          // Text button to update password
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChangePasswordScreen(),
                  ),
                );
              },
              child: const Text(
                'Cambiar contraseña',
                style: TextStyle(
                  color: kPrimaryColor,
                ),
              ),
            ),
          ),

          // Button to save changes
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                await _updateUserData();

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_message),
                    ),
                  );
                }
              },
              child: const Text('Guardar cambios'),
            ),
          ),
        ],
      ),
    );
  }
}

