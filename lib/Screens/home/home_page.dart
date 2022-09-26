import 'package:flutter/material.dart';
import 'package:maneja_tus_cuentas/Screens/home/history.dart';
import 'package:maneja_tus_cuentas/Screens/home/home.dart';
import 'package:maneja_tus_cuentas/Screens/home/profile.dart';
import 'package:maneja_tus_cuentas/Screens/home/statistics.dart';
import 'package:maneja_tus_cuentas/Services/auth.dart';
import 'package:maneja_tus_cuentas/constants.dart';

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
    return IconButton(onPressed: signOut, icon: const Icon(Icons.logout));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: const Text('MTC home'),
          actions: [
            _signOutButton(),
          ],
        ),
        body: _screens[_currentScreen],
        bottomNavigationBar: BottomNavigationBar(
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
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.query_stats),
              label: 'Statistics',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
        ));
  }
}
