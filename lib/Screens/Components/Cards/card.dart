import 'package:flutter/material.dart';

class CardBuilder {
  Color? color = Colors.grey;
  String primaryString = "", secondaryString = "";
  String? moneyString;
  CircularProgressIndicator? circularProgressIndicator;
  ImageIcon? imageIcon;

  // no usar este constructor fuera de esta clase
  CardBuilder({this.color, required this.primaryString, required this.secondaryString, this.moneyString, this.circularProgressIndicator, this.imageIcon});

  CardBuilder.notification({Color? color, required String primaryString, required String secondaryString, ImageIcon? imageIcon}) {
     CardBuilder(color: color, primaryString: primaryString, secondaryString: secondaryString);
  }

  Card build(){
    return Card(
      color: Colors.grey,
      child: Row(
        children: [
          const Icon(Icons.heart_broken),
          Column(
            children: [
              Text(primaryString),
              Text(secondaryString),
            ],
          )
        ],
      ),
    );
  }

}



// class card extends StatefulWidget {
//   const card({Key? key}) : super(key: key);
//
//   @override
//   State<card> createState() => _CardState();
// }
//
// class _CardState extends State<card> {
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: Colors.grey,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.car_crash, color: Colors.green),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: const [
//               Text("Insert Text here"),//TODO cambiar por un widget
//               Text("Insert subtext here")//TODO cambiar por otro widget
//             ],
//           )
//         ],
//       )
//     );
//   }
// }
