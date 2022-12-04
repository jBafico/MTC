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
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => CreateBudget(budget: snapshot.data![index])));
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
                                  //TODO: @franco hacer menu popup
                                  _databaseService
                                      .removeBudget(snapshot.data![index]);
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
}
