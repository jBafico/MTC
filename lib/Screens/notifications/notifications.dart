import 'package:flutter/material.dart';

import '../Components/Cards/card.dart';
import '../Components/upper_menu.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    UpperMenu upperMenu = UpperMenu.notifications();
    return DefaultTabController(
        length: upperMenu.getLength(),
        child: Scaffold(
          appBar: upperMenu.buildBar(context),
          body: CardBuilder.notification(primaryString: "Primary string", secondaryString: "Secondary string").build()
        ));
  }
}