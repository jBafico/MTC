import 'package:flutter/material.dart';
import 'package:maneja_tus_cuentas/Model/Movement.dart';
import 'package:maneja_tus_cuentas/Screens/Components/Cards/movement_card.dart';
import 'package:maneja_tus_cuentas/Services/database.dart';

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
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                                  MovementCard(movement: snapshot.data![index]),
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
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: MovementCard(
                                    movement: snapshot.data![index]),
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
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: MovementCard(
                                    movement: snapshot.data![index]),
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
}
