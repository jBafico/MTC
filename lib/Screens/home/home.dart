import 'package:flutter/material.dart';
import 'package:maneja_tus_cuentas/Screens/Components/Cards/HomeActionCard.dart';
import 'package:maneja_tus_cuentas/Screens/achievements/achievements.dart';
import 'package:maneja_tus_cuentas/Services/database.dart';

import '../../Model/Budget.dart';
import '../../Model/UserData.dart';
import '../../Services/auth.dart';
import '../Components/Cards/budget_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseService _databaseService =
      DatabaseService(uid: AuthService().currentUser!.uid);

  Widget _createAchievementsSection() {
    return const Achievements(
        title: "Tus metas", screenTitle1: "En progreso", screenTitle2: "Listo");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Bienvenido',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14.0,
              )),
          const SizedBox(height: 10),

          // User name
          StreamBuilder(
              stream: _databaseService.userData,
              builder: (context, AsyncSnapshot<UserData> snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    snapshot.data!.name,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text("$snapshot.error");
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),


          const Padding(
            padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
            child: HomeActionCard(),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text(
                'Tus ahorros',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextButton(
                  onPressed: () {},
                  child: const Text('Ver Todo',
                      style: TextStyle(color: Colors.green))),
            ],
          ),

          // User balance
          StreamBuilder(
              stream: _databaseService.userData,
              builder: (context, AsyncSnapshot<UserData> snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    '\$${snapshot.data!.balance}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text("$snapshot.error");
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text(
                'Tus Metas',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => _createAchievementsSection())),
                  child: const Text('Ver Más +',
                      style: TextStyle(color: Colors.green))),
            ],
          ),
          StreamBuilder(
              stream: _databaseService.budgets,
              builder: (context, AsyncSnapshot<List<Budget>> snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: snapshot.data!.isNotEmpty
                        ? BudgetCard(budget: snapshot.data![0])
                        : Container(),
                  );
                } else if (snapshot.hasError) {
                  return Text("$snapshot.error");
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
        ],
      ),
    );
  }
}

