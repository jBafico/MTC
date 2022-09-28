import 'package:flutter/material.dart';

import '../upper_menu.dart';

class Achievements extends StatelessWidget {

  final int _cantTabs = 2;

  const Achievements({Key? key, required this.title, required this.screenTitle1, required this.screenTitle2}) : super(key: key);
  final String title, screenTitle1, screenTitle2;


  @override
  Widget build(BuildContext context) {
    //widget. me deja ver contenido del constructor per se
    //default controller tab se encarga solo



    return DefaultTabController(
        length: _cantTabs,
        child: Scaffold (
          appBar: UpperMenu.achievements().buildBar(context),
          body: const TabBarView(
            children: [
                Text("in progress"),
                Text("Ready")
            ]
          ),
          //preguntamos por el indice actual en el que estamos con context y defaultControler
          floatingActionButton: CircleAvatar(backgroundColor: Colors.green, child: IconButton(icon: const Icon(Icons.add),onPressed: () {},color: Colors.white))
        )
    );
  }
}
