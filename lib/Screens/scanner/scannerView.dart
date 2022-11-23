import 'package:flutter/material.dart';
import 'package:maneja_tus_cuentas/Model/Budget.dart';
import 'package:maneja_tus_cuentas/Screens/Components/Cards/budget_card.dart';
import 'package:maneja_tus_cuentas/Screens/achievements/create_budget.dart';
import 'package:maneja_tus_cuentas/Screens/scanner/scanner.dart';
import 'package:maneja_tus_cuentas/Services/auth.dart';
import 'package:maneja_tus_cuentas/Services/database.dart';

import '../Components/upper_menu.dart';

class ScannerView extends StatefulWidget {
  const ScannerView(
      {Key? key,
        required this.title})
      : super(key: key);
  final String title;

  @override
  State<ScannerView> createState() => _ScannerViewState();
}

class _ScannerViewState extends State<ScannerView> {

final DatabaseService _databaseService =
DatabaseService(uid: AuthService().currentUser!.uid);

@override
Widget build(BuildContext context) {
  //widget. me deja ver contenido del constructor per se
  //default controller tab se encarga solo

  return Scaffold(
          appBar: buildBar(context, "Scanner"),

          //preguntamos por el indice actual en el que estamos con context y defaultControler
          body:Column( mainAxisAlignment: MainAxisAlignment.center,
              children:<Widget>[
                const Image(
                  image: AssetImage('assets/images/ScannerIcon.jpg'),
                ),

            const Text(
            'Ingrese un movimiento escaneando el ticket con tu cámara',
            style: TextStyle(
              color: Colors.black,
              fontSize: 28.0,
              fontWeight: FontWeight.w500,
            ),
              textAlign: TextAlign.center,
          ),
              const Padding(
              padding: EdgeInsets.fromLTRB(0.0, 60.0, 0.0, 0.0)),

            TextButton(
                onPressed: () {
                Navigator.push(
                     context,
                      MaterialPageRoute(
                        builder: (context) => const  ScannerScreen()));},
                child: const Text('Abrir Scanner',
                    style: TextStyle(color: Colors.green,
                                      fontSize: 24.0 ))),]));
}
}


AppBar buildBar(BuildContext context, String tabTitle) {
  return AppBar(
      title: Text(tabTitle, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
  centerTitle: true,
  leading: IconButton(onPressed: ()  => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios), color: Colors.grey),
  backgroundColor: Colors.white);
  }
