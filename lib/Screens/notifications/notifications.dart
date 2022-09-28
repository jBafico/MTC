import 'package:flutter/material.dart';

import '../upper_menu.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    UpperMenu upperMenu = UpperMenu.notifications();
    return DefaultTabController(
        length: upperMenu.getLength(),
        child: Scaffold(
          appBar: upperMenu.buildBar(context),
          body: Image.asset("assets/images/logo_white.png")
        ));
  }
}
