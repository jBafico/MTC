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
          body: notiView() //CardBuilder.notification(primaryString: "Primary string", secondaryString: "Secondary string").build()
        ));
  }

  Widget notiView() {
    return ListView.separated(itemBuilder: (context, index){
      return listViewItem(index);
    }, separatorBuilder: (context, index) {
      return Divider(height: 5);
    }, itemCount: 15);
  }

  Widget bellIcon() {
    return Container(
      height: 50,
      width: 50,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.shade300,
      ),
      child: Icon(Icons.notifications, size: 25, color: Colors.grey.shade700),
    );
  }

  Widget listViewItem(int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          bellIcon(),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  message(index),
                  dayAndTime(index)
                ],
              ),
            ),
          )
        ]
      )
    );
  }

  Widget message(int index) {
    double textSize = 14;
    return Container(
      child: RichText(
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          text: 'Message',
          style: TextStyle(
            fontSize: textSize,
            color: Colors.black,
            fontWeight: FontWeight.bold
          ),
          children: [
            TextSpan(
              text: 'Descripcion',
               style: TextStyle(
                 fontWeight: FontWeight.w400,
               ),
            )
          ],
        ),
      )
    );
  }

  Widget dayAndTime(int index) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'oggi',
            style: TextStyle(
              fontSize: 10,
            ),
          ),
          Text(
            'ora',
            style: TextStyle(
              fontSize: 10,
            ),
          )
        ],
      )
    );
  }
}