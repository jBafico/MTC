import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maneja_tus_cuentas/Services/auth.dart';
import 'package:maneja_tus_cuentas/constants.dart';

import '../../Model/UserData.dart';
import '../../Services/database.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();

  final DatabaseService _databaseService =
      DatabaseService(uid: AuthService().currentUser!.uid);

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Your Profile',
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
                Center(
                    child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: // User name
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
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                          }),
                )),
              ],
            ),
          ),
        ),

        // Field to change name
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
              controller: _nameController,
            ),
          ),
        ),

        // Button to change name
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () async {
              await _databaseService
                  .updateUserName(_nameController.text)
                  .then((value) => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Name updated'))))
                  .onError((error, stackTrace) => ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(
                          content: Text('Error updating name'))));
            },
            child: const Text('Edit Profile'),
          ),
        ),
      ],
    );
  }
}
