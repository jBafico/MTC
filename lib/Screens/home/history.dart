import 'package:flutter/material.dart';
import 'package:maneja_tus_cuentas/Model/Movement.dart';
import 'package:maneja_tus_cuentas/Screens/Components/Cards/movement_card.dart';
import 'package:maneja_tus_cuentas/Screens/new_movement.dart';
import 'package:maneja_tus_cuentas/Services/database.dart';

import '../../Model/UserData.dart';
import '../../Services/auth.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final int _cantTabs = 3;

  final DatabaseService _databaseService =
      DatabaseService(uid: AuthService().currentUser!.uid);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: _cantTabs,
        child: Scaffold(
            appBar: AppBar(
              title: const TabBar(
                tabs: [
                  Tab(text: 'Todos'),
                  Tab(text: 'Ingresos'),
                  Tab(text: 'Gastos'),
                ],
              ),
            ),
            body: TabBarView(children: [
              // Scrollable list of all movements
              StreamBuilder(
                  stream: _databaseService.movements,
                  builder: (context, AsyncSnapshot<List<Movement>> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onLongPress: () async {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) => _buildPopupDialog(context, snapshot.data![index]),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:
                                MovementCard(movement: snapshot.data![index]),
                              ),
                            );
                          });
                    } else if (snapshot.hasError) {
                      return Text("$snapshot.error");
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  }),
              // Scrollable list of incomes
              StreamBuilder(
                  stream: _databaseService.movements,
                  builder: (context, AsyncSnapshot<List<Movement>> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            if (snapshot.data![index].type == 'income') {
                              return GestureDetector(
                                onLongPress: () async {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) => _buildPopupDialog(context, snapshot.data![index]),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:
                                  MovementCard(movement: snapshot.data![index]),
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
              // Scrollable list of spendings
              StreamBuilder(
                  stream: _databaseService.movements,
                  builder: (context, AsyncSnapshot<List<Movement>> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            if (snapshot.data![index].type == 'spending') {
                              return GestureDetector(
                                onLongPress: () async {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) => _buildPopupDialog(context, snapshot.data![index]),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:
                                  MovementCard(movement: snapshot.data![index]),
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
            ])));
  }

  Future<void> deleteMovement(Movement movement) async {
    _databaseService.removeMovement(movement);
    // Get user data
    UserData userData = await _databaseService.getUserData();

    userData
        .updateBalance((movement.amount) * (movement.type == 'income' ? -1 : 1));

    _databaseService
        .updateUserBalance(userData.balance);
  }

  Widget _buildPopupDialog(BuildContext context, Movement movement) {
    return SimpleDialog(
      title: const Text('Seleccionar opción'),
      children: <Widget>[
        SimpleDialogOption(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => NewMovementScreen(movement: movement))); //snapshot.data![index]
          },
          child: const Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              'Editar movimiento',
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
              builder: (BuildContext context) => _buildDeleteDialog(context, movement),
            );
          },
          child: const Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              'Eliminar movimiento',
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

  Widget _buildDeleteDialog(BuildContext context, Movement movement) {
    return AlertDialog(
      title: const Text('Confirmar'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text("¿Deseas eliminar este movimiento? Su balance se verá afectado. Esta acción no se puede deshacer."),
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
              deleteMovement(movement);
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
}
