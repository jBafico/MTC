import 'package:flutter/material.dart';

class UpperMenu {

  UpperMenu.achievements(){
    _title = "Tus metas";
    _screenTitleList = ["En progreso", "Listo"];
  }

  UpperMenu.history(){
    _title = "Historial";
    _screenTitleList = ["Todo", "Enviado", "Recibido"];
    _hasBackArrow = false;
  }

  UpperMenu.notifications(){
    _title = "Notificaciones";
    _screenTitleList = ["Todas", "Sin leer"];
  }

  late final String _title;
  late final List<String> _screenTitleList;
  bool _hasBackArrow = true;

  int getLength(){
    return _screenTitleList.length;
  }

  List<Tab> _createTabList() {
    List<Tab> tabList = [];
    for (var s in _screenTitleList){
      tabList.add(Tab(text: s,));
    }
    return tabList;
  }

  AppBar buildBar(BuildContext context) {
    return AppBar(
      title: Text(_title, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
      centerTitle: true,
      leading: _hasBackArrow ? IconButton(onPressed: ()  => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios), color: Colors.grey) : null,
      backgroundColor: Colors.white,
      bottom: TabBar(
        indicatorColor: Colors.green,
        labelColor: Colors.green,
        unselectedLabelColor: Colors.grey,
        tabs: _createTabList(),
      ),
    );
  }

}