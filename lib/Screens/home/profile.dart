import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maneja_tus_cuentas/Services/auth.dart';
import 'package:maneja_tus_cuentas/constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

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
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Your Profile',
            style: TextStyle(
              fontSize: 30,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 8.0),
          child: Card(
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(2.0),
                  child: ProfileIcon(),
                ),
                Center(child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                      _userName == null ? 'Loading' : '$_userName',
                      style: const TextStyle(
                          fontSize: 24
                      )
                  ),
                )),

              ],
            ),
          ),
        ),

      ],
    );
  }
}


class ProfileIcon extends StatelessWidget {
  const ProfileIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Color(0xFFBCC3FF),
            child: Icon(Icons.person, size: 40, color: kPrimaryColor),
          ),
        ),
        Positioned(
          bottom: 5,
          right: 5,
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: kPrimaryColor,
            ),
            child: const Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(Icons.edit_outlined, color: Colors.white, size: 13),
            ),
          ),
        ),
      ],
    );
  }
}
