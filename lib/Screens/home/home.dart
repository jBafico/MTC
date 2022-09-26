import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(_userName == null ? 'Loading' : 'Hi $_userName'),
    );
  }
}
