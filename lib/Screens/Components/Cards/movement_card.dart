import 'package:flutter/material.dart';
import 'package:maneja_tus_cuentas/Model/Movement.dart';
import 'package:maneja_tus_cuentas/constants.dart';

class MovementCard extends StatelessWidget {
  final Movement movement;

  const MovementCard({Key? key, required this.movement}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      elevation: 0,
      child: InkWell(
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
