import 'package:flutter/material.dart';
import 'package:maneja_tus_cuentas/Services/auth.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String _message = "";

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final AuthService _auth = AuthService();

  @override
  initState() {
    super.initState();
  }

  void _togglePassword() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleConfirmPassword() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  Future _updatePassword() async {
    if (_passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      _message = "Por favor, rellene todos los campos";
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      _message = "Las contraseñas no coinciden";
      return;
    }

    try {
      await _auth.updatePassword(_passwordController.text);

      _message = 'Contraseña actualizada';
    } on Exception {
      _message = 'Error al actualizar la contraseña';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cambiar contraseña'),
      ),
      body: Column(
        children: [
const SizedBox(height: 20),

          // Contraseña
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Contraseña',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),

          // Field to change password
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: _togglePassword,
                  icon: const Icon(Icons.remove_red_eye_outlined),
                ),
              ),
              controller: _passwordController,
            ),
          ),

          // Confirmar contraseña
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Confirmar contraseña',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),

          // Field to confirm password
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              obscureText: _obscureConfirmPassword,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: _toggleConfirmPassword,
                  icon: const Icon(Icons.remove_red_eye_outlined),
                ),
              ),
              controller: _confirmPasswordController,
            ),
          ),

          // Button to save changes
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                await _updatePassword();

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_message),
                    ),
                  );
                }
              },
              child: const Text('Cambiar contraseña'),
            ),
          ),
        ],
      ),
    );
  }
}
