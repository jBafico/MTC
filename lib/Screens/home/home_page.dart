import 'package:flutter/material.dart';
import 'package:maneja_tus_cuentas/Screens/home/history.dart';
import 'package:maneja_tus_cuentas/Screens/home/home.dart';
import 'package:maneja_tus_cuentas/Screens/home/profile.dart';
import 'package:maneja_tus_cuentas/Screens/home/statistics.dart';
import 'package:maneja_tus_cuentas/Services/auth.dart';
import 'package:maneja_tus_cuentas/constants.dart';

import '../achievements/achievements.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // This widget is the home page of your application. It is stateful, meaning


  int _currentScreen = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const HistoryScreen(),
    const StatisticsScreen(),
    const ProfileScreen(),
  ];

  Future signOut() async {
    await AuthService().signOut();
  }

  Widget _signOutButton() {
    return IconButton(onPressed: signOut, icon: const Icon(Icons.logout),);
  }


AppBar _appBarHandler(){
    String title = "";

    switch(_currentScreen){
      case 0: title = "Menú Principal";
              break;
      case 1: title = "Historial";
              break;
      case 2: title = "Estadísticas";
              break;
      case 3: title = "Perfil";
    }

    return AppBar(
      elevation: 0,
      title: Text(title),
      actions: [
        _signOutButton(),
      ],
    );
}

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
        key: const Key("HomePageScaffold"),
        appBar: _appBarHandler(),
        //appBar: _appBarHandler(),
        body: _screens[_currentScreen],
        bottomNavigationBar: BottomNavigationBar(
          key: const Key("BottomBar"),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: kPrimaryColor,
          currentIndex: _currentScreen,
          onTap: (index) {
            setState(() {
              _currentScreen = index;
            });
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Principal',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Historial',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.query_stats),
              label: 'Estadísticas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Perfil',
            ),
          ],
        ));
  }
}
