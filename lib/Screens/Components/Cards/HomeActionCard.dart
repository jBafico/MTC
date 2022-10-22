
import 'package:flutter/material.dart';
import 'package:maneja_tus_cuentas/Screens/new_movement.dart';

class HomeActionCard extends StatelessWidget {
  const HomeActionCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      // It has two buttons with custom icons and text below, one for adding a new movement and one for scanning a receipt
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Title with divider line
            const Padding(
              padding: EdgeInsets.fromLTRB(8.0, 0, 0, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Acciones",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 1,
                color: Colors.grey.shade200,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        // Push to new movement screen
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const NewMovementScreen()));
                      },
                      child: const CircleAvatar(
                        backgroundColor: Color(0xFFBCC3FF),
                        child: Image(
                          image: AssetImage('assets/images/SendMoney.png'),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                      child: Text('Ingresar'),
                    ),
                    const Text('movimiento')
                  ],
                ),
                Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {},
                      child: const CircleAvatar(
                        backgroundColor: Color(0xFFBCC3FF),
                        child: Image(
                          image: AssetImage('assets/images/Pay.png'),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                      child: Text('Escanear'),
                    ),
                    const Text('ticket'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),

    );
  }
}
