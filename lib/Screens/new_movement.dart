
import 'package:flutter/material.dart';
import 'package:maneja_tus_cuentas/Model/Movement.dart';
import 'package:maneja_tus_cuentas/Model/UserData.dart';
import 'package:maneja_tus_cuentas/Services/database.dart';

import '../Model/Category.dart';
import '../Services/auth.dart';
import '../constants.dart';

class NewMovementScreen extends StatefulWidget {
  const NewMovementScreen({Key? key}) : super(key: key);

  @override
  State<NewMovementScreen> createState() => _NewMovementScreenState();
}

class _NewMovementScreenState extends State<NewMovementScreen> {
  final DatabaseService _databaseService =
      DatabaseService(uid: AuthService().currentUser!.uid);

  final TextEditingController _controllerDescription = TextEditingController();

  // Amount of money, number controller
  final TextEditingController _controllerAmount = TextEditingController();

  Category? _currentCategory;

  int _currentType = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingresar movimiento'),
        backgroundColor: Colors.grey.shade50,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      // Body, it has a form with a number selector, a dropdown category selector,
      // a selector for defining if it is spending or income
      // and a text field for the description
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Amount selector
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 8.0),
                child: const Text('Monto',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Ingrese el monto',
                ),
                keyboardType: TextInputType.number,
                controller: _controllerAmount,
              ),

              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 8.0),
                child: const Text('Descripción',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              ),
              // Description text field
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Ingrese una descripción',
                ),
                keyboardType: TextInputType.text,
                controller: _controllerDescription,
              ),

              // Category selector
              Container(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 4.0),
                alignment: Alignment.centerLeft,
                child: DropdownButton<Category>(
                  hint: const Text('Agregar categoria'),
                  value: _currentCategory,
                  icon: const Icon(Icons.add),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: kPrimaryColor),
                  underline: Container(
                    height: 2,
                    color: kPrimaryColor,
                  ),
                  onChanged: (Category? newValue) {
                    setState(() {
                      _currentCategory = newValue!;
                    });
                  },
                  items: Category.categories
                      .map<DropdownMenuItem<Category>>((Category value) {
                    return DropdownMenuItem<Category>(
                      value: value,
                      child: Row(
                        children: [
                          Icon(value.icon),
                          const SizedBox(width: 10),
                          Text(value.name),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              // Spending or income selector
              Row(
                children: [
                  const Text('Gasto'),
                  Radio(
                    value: 1,
                    groupValue: _currentType,
                    onChanged: (value) {
                      setState(() {
                        _currentType = value as int;
                      });
                    },
                  ),
                  const Text('Ingreso'),
                  Radio(
                    value: 2,
                    groupValue: _currentType,
                    onChanged: (value) {
                      setState(() {
                        _currentType = value as int;
                      });
                    },
                  ),
                ],
              ),

              // Submit button
              ElevatedButton(
                onPressed: () async {
                  // If the amount is not a number, show an error
                  if (double.tryParse(_controllerAmount.text) == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('El monto debe ser un número'),
                      ),
                    );
                    return;
                  }

                  // If the amount is 0, show an error
                  if (double.parse(_controllerAmount.text) == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('El monto debe ser mayor a 0'),
                      ),
                    );
                    return;
                  }

                  // If the category is null, show an error
                  if (_currentCategory == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Debe seleccionar una categoria'),
                      ),
                    );
                    return;
                  }

                  // If the description is empty, show an error
                  if (_controllerDescription.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Debe ingresar una descripción'),
                      ),
                    );
                    return;
                  }

                  try {
                    // If everything is ok, add the movement to the database
                    await _databaseService.updateMovement(
                      Movement(
                        amount: double.parse(_controllerAmount.text),
                        category: _currentCategory ?? Category.defaultCategory,
                        description: _controllerDescription.text,
                        type: _currentType == 1 ? 'spending' : 'income',
                        date: DateTime.now(),
                      ),
                    );


                    // Get user data
                    UserData userData = await _databaseService.getUserData();

                    // Update user data
                    userData
                        .updateBalance(double.parse(_controllerAmount.text) * (_currentType == 1 ? -1 : 1));

                    _databaseService
                        .updateUserBalance(userData.balance)
                        .then((value) => Navigator.pop(context));
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Error al ingresar el movimiento'),
                      ),
                    );
                    return;
                  }
                },
                child: const Text('Ingresar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
