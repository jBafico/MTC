import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maneja_tus_cuentas/Screens/achievements/achievements.dart';

import '../../Services/auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final User? _user = AuthService().currentUser;

  String? _userName;

  final users = FirebaseFirestore.instance.collection('users');

  void _getUserName() async {
    users.doc(_user!.uid).get().then((DocumentSnapshot doc) => {
      setState(() {
        _userName = doc.get('name');
      })
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserName();
  }

  Widget _createAchievementsSection(){
    return const Achievements(title: "Tus metas", screenTitle1: "En progreso", screenTitle2: "Listo");
  }

  @override
  Widget build(BuildContext context) {
    return
      Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget> [
            Text(
              'Bienvenido',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14.0,
              )
            ),
            SizedBox(height: 10),
            Text(
              _userName == null ? 'Loading' : '$_userName',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget> [
                Text(
                  'Tus ahorros',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextButton(
                    onPressed: () {},
                    child: Text(
                      'Ver Todo',
                      style: TextStyle(
                        color: Colors.green
                      )
                    )
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget> [
                Text(
                  'Tus Metas',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => _createAchievementsSection())),
                    child: const Text(
                        'Ver Más +',
                        style: TextStyle(
                            color: Colors.green
                        )
                    )
                )
              ],
            ),
          ],
        ),
      );
  }
}
