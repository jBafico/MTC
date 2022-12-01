import 'package:flutter/material.dart';
import 'package:maneja_tus_cuentas/Model/Movement.dart';
import 'package:maneja_tus_cuentas/Services/database.dart';
import 'package:maneja_tus_cuentas/constants.dart';

import '../../../Model/UserData.dart';
import '../../../Services/auth.dart';

class MovementCard extends StatelessWidget {
  final Movement movement;
  final DatabaseService _databaseService = DatabaseService(uid: AuthService().currentUser!.uid);

  MovementCard({Key? key, required this.movement}) : super(key: key);

  Widget _buildPopupDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirmar'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text("¿Deseas eliminar este movimiento? Su balance se verá afectado. Esta acción no se puede deshacer."),
        ],
      ),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.red,
            padding: const EdgeInsets.all(10.0),
            textStyle: const TextStyle(fontSize: 15),
          ),
            child: const Text('ELIMINAR'),
            onPressed: () async {
              try {
                _databaseService.removeMovement(movement);
                // Get user data
                UserData userData = await _databaseService.getUserData();

                userData
                    .updateBalance(movement.amount * (movement.type == 'income' ? -1 : 1));

                _databaseService
                    .updateUserBalance(userData.balance)
                    .then((value) => Navigator.pop(context));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Error al eliminar movimiento'),
                  ),
                );
              }
            }
        ),
        TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.all(10.0),
            textStyle: const TextStyle(fontSize: 15),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cerrar'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      elevation: 0,
      child: InkWell(
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) => _buildPopupDialog(context),
          );
        },
      child: Row(
        children: <Widget>[
          SizedBox(
            height: 80,
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Icon(
                  movement.category.icon,
                  size: 40,
                  color: kPrimaryColor,
                ),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(movement.description),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                    child: Text(
                        "${movement.date.day}/${movement.date.month}/${movement.date.year}",
                        style: const TextStyle(color: kPrimaryColor)),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              (movement.type == 'income' ? '+\$' : '-\$') +
                  movement.amount.toString(),
              style: const TextStyle(color: kPrimaryColor),
            ),
          ),
        ],
      ),
      )
    );
  }
}
