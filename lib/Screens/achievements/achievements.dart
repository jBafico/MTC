import 'package:flutter/material.dart';

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
          appBar: AppBar(

            //esto es un boton que vuelve a la pagina anterior
            leading: IconButton(onPressed: ()  => Navigator.pop(context) ,icon: const Icon(Icons.arrow_back_ios),color: Colors.grey),
            backgroundColor: Colors.white,
            title: Text(title,style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            centerTitle: true,
            bottom: TabBar(
              indicatorColor: Colors.green,
              labelColor: Colors.green,
              unselectedLabelColor: Colors.grey,
              /*importa el orden, se corresponde uno a uno para la TabBarView*/
              tabs: [ Tab(text: screenTitle1) , Tab(text: screenTitle2)],
            ),
          ),
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
