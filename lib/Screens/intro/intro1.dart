import 'package:flutter/material.dart';

/*
class Messages {
  static const mensaje1 = "Ingresar gastos!";
  static const mensaje2 = "Lleva registro de tus gastos asi \n estas informado siempre de tu situacion\n actual.";

}
 */


class Intros extends StatelessWidget {

  final Color buttonMessageColor, buttonColor;
  final String buttonMessage, mainMessage, auxMessage, image;

  const Intros({super.key, required this.image,required this.buttonColor,required this.buttonMessage,required this.mainMessage, required this.auxMessage,required this.buttonMessageColor} );

  @override
  Widget build(BuildContext context) {

    var mainTextStyle = const TextStyle(fontWeight: FontWeight.bold,fontSize: 20);


    return Column(
      children: [
        //TODO descargar imagen en formato svg
        Container(
            padding: const EdgeInsets.all(100),
            child: Image.asset("images/$image", fit: BoxFit.cover )
        ),
        Column(
          children:  [
            Container(
                padding: const EdgeInsets.all(25),
                /* postfix exclamation mark (!) takes the expression on the left and casts it to its underlying non-nullable type. So it changes:*/
                child: Text(mainMessage, textAlign: TextAlign.center, style: mainTextStyle)
            ),
            Container(
              padding : const EdgeInsets.all(25),
              child: Text(auxMessage, textAlign: TextAlign.center),
            )
          ],
        ),
        ElevatedButton(
          onPressed: () {},
          // style: ButtonStyle(elevation: MaterialStateProperty(12.0 )),
          style: ElevatedButton.styleFrom(
              elevation: 12.0,
              textStyle: TextStyle(color: buttonMessageColor),
              backgroundColor: buttonColor
          ),
          child: Text(buttonMessage),
        ),
      ],
    );

  }
}