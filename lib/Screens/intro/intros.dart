import 'package:flutter/material.dart';

class Intros extends StatelessWidget {
  final Color buttonMessageColor, buttonColor;
  final String buttonMessage, mainMessage, auxMessage, image, nextButtonRoute;

  const Intros(
      {Key? key,
      required this.image,
      required this.buttonColor,
      required this.buttonMessage,
      required this.mainMessage,
      required this.auxMessage,
      required this.buttonMessageColor,
      required this.nextButtonRoute})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mainTextStyle = const TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
    var secondaryTextStyle = const TextStyle(fontSize: 15,color: Colors.grey);

    return Scaffold(
    backgroundColor: Colors.white,
        body: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        //TODO descargar imagen en formato svg
        Container(
            padding: const EdgeInsets.all(100),
            child: Image.asset("assets/images/$image", fit: BoxFit.cover)),
        Column(
          children: [
            Container(
                padding: const EdgeInsets.all(25),
                /* postfix exclamation mark (!) takes the expression on the left and casts it to its underlying non-nullable type. So it changes:*/
                child: Text(mainMessage,
                    textAlign: TextAlign.center, style: mainTextStyle)),
            Container(
              padding: const EdgeInsets.all(25),
              child: Text(auxMessage, textAlign: TextAlign.center,style: secondaryTextStyle),
            )
          ],
        ),

        ElevatedButton(
            onPressed: () =>
                Navigator.popAndPushNamed(context, nextButtonRoute),
            // style: ButtonStyle(elevation: MaterialStateProperty(12.0 )),
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateColor.resolveWith((states) => buttonColor),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              )),
            ),
            child: Text(buttonMessage)),
      ],
    ));
  }
}
