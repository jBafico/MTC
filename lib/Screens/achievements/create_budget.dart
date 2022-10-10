import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maneja_tus_cuentas/Model/Budget.dart';
import 'package:maneja_tus_cuentas/Screens/authentication/login.dart';
import 'package:maneja_tus_cuentas/Services/auth.dart';
import 'package:maneja_tus_cuentas/Services/database.dart';
import 'package:maneja_tus_cuentas/constants.dart';

class CreateBudget extends StatefulWidget {
  const CreateBudget({Key? key}) : super(key: key);

  @override
  State<CreateBudget> createState() => _CreateBudgetState();
}

class _CreateBudgetState extends State<CreateBudget> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
                width: MediaQuery.of(context).size.width,
              ),
              SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "Crear Presupuesto",
                        style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 36),
                      ),
                      const SizedBox(height: defaultPadding * 2),
                      Row(
                        children: const [
                          Spacer(),
                          Expanded(
                            flex: 8,
                            child: BudgetForm(),
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
    );
  }
}

class BudgetForm extends StatefulWidget {
  const BudgetForm({
    Key? key,
  }) : super(key: key);

  @override
  State<BudgetForm> createState() => _BudgetFormState();
}

class _BudgetFormState extends State<BudgetForm> {
  // Initially password is obscure

  final TextEditingController _controllerName = TextEditingController();

  final TextEditingController _controllerDescription = TextEditingController();

  // Amount of money, number controller
  final TextEditingController _controllerAmount = TextEditingController();

  final DatabaseService _databaseService = DatabaseService(uid: AuthService().currentUser!.uid);


  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(4.0, 0, 0, 8.0),
            child: const Text(
              'Nombre',
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
              'Descripción',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
          TextField(
            controller: _controllerDescription,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            cursorColor: kPrimaryColor,
          ),
          // Amount of money
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(4.0, 16.0, 0, 8.0),
            child: const Text(
              'Presupuesto',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
          TextField(
            controller: _controllerAmount,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.attach_money),
            ),
            cursorColor: kPrimaryColor,
          ),
          const SizedBox(height: defaultPadding),
          Hero(
            tag: "create_btn",
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

                await _databaseService.updateBudget(
                  Budget(
                    name: _controllerName.text,
                    description: _controllerDescription.text,
                    amount: double.parse(_controllerAmount.text),
                    completed: false,
                    spent: 0,
                  ),
                ).then((value) => Navigator.pop(context));
              },
              child: const Text(
                "Guardar",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
          Hero(
            tag: "cancel_btn",
            child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.grey.shade50),
                elevation: MaterialStateProperty.all<double>(0),
                side: MaterialStateProperty.all<BorderSide>(const BorderSide(color: Colors.black)),
                minimumSize: MaterialStateProperty.all(
                    Size(MediaQuery.of(context).size.width, 40)),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Cancelar",
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
        ],
      ),
    );
  }
}
