import 'package:flutter/material.dart';
import 'package:maneja_tus_cuentas/Model/Budget.dart';
import 'package:maneja_tus_cuentas/Model/Category.dart';
import 'package:maneja_tus_cuentas/Services/auth.dart';
import 'package:maneja_tus_cuentas/Services/database.dart';
import 'package:maneja_tus_cuentas/constants.dart';

class CreateBudget extends StatefulWidget {
  const CreateBudget({Key? key, this.budget}) : super(key: key);

  final Budget? budget;

  @override
  State<CreateBudget> createState() => _CreateBudgetState();
}

class _CreateBudgetState extends State<CreateBudget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * (widget.budget == null ? 0.1 : 0.05),
              width: MediaQuery.of(context).size.width,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  widget.budget == null
                      ? "Crear Presupuesto"
                      : "Editar Presupuesto",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 36),
                ),
                const SizedBox(height: defaultPadding * 2),
                Row(
                  children: [
                    const Spacer(),
                    Expanded(
                      flex: 8,
                      child: BudgetForm(budget: widget.budget),
                    ),
                    const Spacer(),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BudgetForm extends StatefulWidget {
  const BudgetForm({Key? key, this.budget}) : super(key: key);

  final Budget? budget;

  @override
  State<BudgetForm> createState() => _BudgetFormState();
}

class _BudgetFormState extends State<BudgetForm> {
  // Initially password is obscure

  TextEditingController _controllerName = TextEditingController();

  TextEditingController _controllerDescription = TextEditingController();

  // Amount of money, number controller
  final TextEditingController _controllerAmount = TextEditingController();

  TextEditingController _controllerTotalAmountEdition = TextEditingController();

  // Category
  Category? _currentCategory;

  final DatabaseService _databaseService =
      DatabaseService(uid: AuthService().currentUser!.uid);

  @override
  void initState() {
    // TODO: implement initState
    _controllerName = TextEditingController(
        text:
        widget.budget == null ? _controllerName.text : widget.budget!.name);
    _controllerDescription = TextEditingController(
        text: widget.budget == null
            ? _controllerDescription.text
            : widget.budget!.description);

    _controllerTotalAmountEdition = TextEditingController(
        text: widget.budget == null
            ? _controllerTotalAmountEdition.text
            : "${widget.budget!.amount}");

    _currentCategory = widget.budget == null
        ? _currentCategory
        : widget.budget!.category;
    super.initState();
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

          widget.budget == null
              ? Container()
              : Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(4.0, 16.0, 0, 8.0),
                  child: const Text(
                    'Presupuesto',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),

          widget.budget == null
              ? Container()
              : TextField(
                  controller: _controllerTotalAmountEdition,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.attach_money),
                  ),
                  cursorColor: kPrimaryColor,
                ),
          const SizedBox(height: defaultPadding),

          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(4.0, 8.0, 0, 4.0),
            child: Text(
              widget.budget == null ? 'Presupuesto' : 'Monto a destinar',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
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

          // Dropdown menu with categories
          Container(
            padding: const EdgeInsets.fromLTRB(4.0, 0, 0, 4.0),
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
              items:
              Category.categories.map<DropdownMenuItem<Category>>((Category value) {
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

                // Validate form

                if (_controllerName.text.isEmpty ||
                    _controllerDescription.text.isEmpty ||
                    (_controllerAmount.text.isEmpty && widget.budget == null)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, rellena todos los campos'),
                    ),
                  );
                  return;
                }

                // Validate category
                if (_currentCategory == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, selecciona una categoria'),
                    ),
                  );
                  return;
                }

                if (widget.budget == null) {
                  await _databaseService
                      .updateBudget(
                        Budget(
                          name: _controllerName.text,
                          description: _controllerDescription.text,
                          amount: double.parse(_controllerAmount.text),
                          completed: false,
                          spent: 0,
                          category: _currentCategory?? Category.defaultCategory,
                        ),
                      )
                      .then((value) => Navigator.pop(context));
                } else {
                  await _databaseService.removeBudget(widget.budget!);

                  try {
                    widget.budget!
                        .updateSpent(double.parse(_controllerAmount.text));
                  } on FormatException {
                    // TODO: manejo de errores
                  }

                  try {
                    widget.budget!.amount =
                        double.parse(_controllerTotalAmountEdition.text);
                  } on FormatException {
                    // TODO: manejo de errores
                  }

                  // Por si me paso de amount
                  if (widget.budget!.spent >= widget.budget!.amount) {
                    widget.budget!.completed = true;
                    widget.budget!.spent = widget.budget!.amount;
                  }

                  widget.budget!.name = _controllerName.text;
                  widget.budget!.description = _controllerDescription.text;
                  widget.budget!.category = _currentCategory?? Category.defaultCategory;

                  await _databaseService
                      .updateBudget(widget.budget!)
                      .then((value) => Navigator.pop(context));
                }
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
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.grey.shade50),
                elevation: MaterialStateProperty.all<double>(0),
                side: MaterialStateProperty.all<BorderSide>(
                    const BorderSide(color: Colors.black)),
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
