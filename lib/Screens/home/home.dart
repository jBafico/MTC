import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maneja_tus_cuentas/Screens/achievements/achievments.dart';

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

  Widget _createAchievmentsSection(){
    return const Achievments(title: "Tus metas", screenTitle1: "En progreso", screenTitle2: "Listo");
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Text(_userName == null ? 'Loading' : 'Hi $_userName'),
          Align(alignment: Alignment.bottomRight,child: TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => _createAchievmentsSection())), child: const Text("Ver mas", style: TextStyle(color: Colors.green))))
        ],

      ),
    );
  }
}
