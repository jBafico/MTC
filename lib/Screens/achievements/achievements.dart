import 'package:flutter/material.dart';
import 'package:maneja_tus_cuentas/Model/Budget.dart';
import 'package:maneja_tus_cuentas/Screens/Components/Cards/budget_card.dart';
import 'package:maneja_tus_cuentas/Screens/achievements/create_budget.dart';
import 'package:maneja_tus_cuentas/Services/auth.dart';
import 'package:maneja_tus_cuentas/Services/database.dart';

import '../Components/upper_menu.dart';

class Achievements extends StatefulWidget {
  const Achievements(
      {Key? key,
      required this.title,
      required this.screenTitle1,
      required this.screenTitle2})
      : super(key: key);
  final String title, screenTitle1, screenTitle2;

  @override
  State<Achievements> createState() => _AchievementsState();
}

class _AchievementsState extends State<Achievements> {
  final int _cantTabs = 2;

  final TextEditingController _textFieldController = TextEditingController();

  final DatabaseService _databaseService =
      DatabaseService(uid: AuthService().currentUser!.uid);

  @override
  Widget build(BuildContext context) {
    //widget. me deja ver contenido del constructor per se
    //default controller tab se encarga solo

    return DefaultTabController(
        length: _cantTabs,
        child: Scaffold(
            appBar: UpperMenu.achievements().buildBar(context),
            body: TabBarView(children: [
              // Scrollable list of cards
              StreamBuilder(
                  stream: _databaseService.budgets,
                  builder: (context, AsyncSnapshot<List<Budget>> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            if (!snapshot.data![index].completed) {
                              return GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) => _buildAddMoneyDialog(context, snapshot.data![index]),
                                  );
                                },
                                onLongPress: () async {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) => _buildPopupDialog(context, snapshot.data![index]),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:
                                      BudgetCard(budget: snapshot.data![index]),
                                ),
                              );
                            } else {
                              return Container();
                            }
                          });
                    } else if (snapshot.hasError) {
                      return Text("$snapshot.error");
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  }),

              StreamBuilder(
                  stream: _databaseService.budgets,
                  builder: (context, AsyncSnapshot<List<Budget>> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            if (snapshot.data![index].completed) {
                              return GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) => _buildDeleteDialog(context, snapshot.data![index]),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:
                                      BudgetCard(budget: snapshot.data![index]),
                                ),
                              );
                            } else {
                              return Container();
                            }
                          });
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  }),
            ]),
            //preguntamos por el indice actual en el que estamos con context y defaultControler
            floatingActionButton: CircleAvatar(
                backgroundColor: Colors.green,
                child: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CreateBudget()));
                    },
                    color: Colors.white))));
  }

  Future<void> updateBudget(Budget budget) async {
    await _databaseService.removeBudget(budget);

    try {
      budget
          .updateSpent(double.parse(_textFieldController.text));
    } on FormatException {
      // TODO: manejo de errores
    }

    await _databaseService
        .updateBudget(budget)
        .then((value) => Navigator.pop(context));

    _textFieldController.clear();
  }

  Widget _buildPopupDialog(BuildContext context, Budget budget) {
    return SimpleDialog(
      title: const Text('Seleccionar opción'),
      children: <Widget>[
        SimpleDialogOption(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CreateBudget(budget: budget)));
            },
            child: const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Editar meta',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            )
        ),
        SimpleDialogOption(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => _buildDeleteDialog(context, budget),
              );
            },
            child: const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Eliminar meta',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 15,
                ),
              ),
            )
        ),
      ],
    );
  }

  Widget _buildDeleteDialog(BuildContext context, Budget budget) {
    return AlertDialog(
      title: const Text('Confirmar'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text("¿Deseas eliminar esta meta? Esta acción no se puede deshacer."),
        ],
      ),
      actions: <Widget>[
        TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
              padding: const EdgeInsets.all(10.0),
              textStyle: const TextStyle(fontSize: 15),
            ),
            child: const Text('ELIMINAR'),
            onPressed: () async {
              _databaseService.removeBudget(budget);
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            }
        ),
        TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.all(10.0),
            textStyle: const TextStyle(fontSize: 15),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cerrar'),
        ),
      ],
    );
  }

  Widget _buildAddMoneyDialog(BuildContext context, Budget budget) {
    return AlertDialog(
      title: const Text('Destinar dinero a meta'),
      content: TextFormField(
        decoration: const InputDecoration(
          hintText: 'Ingrese el monto',
        ),
        keyboardType: TextInputType.number,
        controller: _textFieldController,
      ),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.all(10.0),
            textStyle: const TextStyle(fontSize: 15),
          ),
          child: const Text('Cerrar'),
          onPressed: () {
            setState(() {
              Navigator.pop(context);
            });
          },
        ),
        TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.all(10.0),
            textStyle: const TextStyle(fontSize: 15),
          ),
          child: const Text('Agregar'),
          onPressed: () {
            setState(() {
              updateBudget(budget);
            });
          },
        ),
      ],
    );
  }
}
