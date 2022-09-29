import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';

class Intros extends StatefulWidget {
  const Intros({super.key});

  @override
  State<StatefulWidget> createState() {
    return IntrosState();
  }
}

class IntrosState extends State<Intros> {
  List<ContentConfig> listContentConfig = [];
  Color activeColor = Colors.green;
  Color inactiveColor = Colors.grey;
  double sizeIndicator = 20;

  @override
  void initState() {
    super.initState();

    listContentConfig.add(
      const ContentConfig(
        title:
        "Ingresa tus gastos",
        maxLineTitle: 2,
        styleTitle: TextStyle(
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
        pathImage: "assets/images/intro1.jpg",
        description:
        "Lleva registro de tus gastos asi estas\ninformado siempre de tu situacion actual.",
        styleDescription: TextStyle(
          color: Colors.grey,
          fontSize: 15.0,
        ),
        marginDescription: EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          top: 20.0,
          bottom: 70.0,
        ),
        backgroundColor: Colors.white,
      ),
    );
    listContentConfig.add(
      const ContentConfig(
      title:
      "¡Genera ganancias!",
      maxLineTitle: 2,
      styleTitle: TextStyle(
        color: Colors.black,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
      pathImage: "assets/images/intro2.jpg",
      description:
      "¡Defini tu presupuesto y alcanza tu metas!",
      styleDescription: TextStyle(
        color: Colors.grey,
        fontSize: 15.0,
      ),
      marginDescription: EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        top: 20.0,
        bottom: 70.0,
      ),
      backgroundColor: Colors.white,
      ),
    );
    listContentConfig.add(
      const ContentConfig(
        title:
        "Fácil de usar",
        maxLineTitle: 2,
        styleTitle: TextStyle(
        color: Colors.black,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        ),
        pathImage: "assets/images/intro3.jpg",
        description:
        "Una manera sencilla y\nrapida de organizar gastos",
        styleDescription: TextStyle(
          color: Colors.grey,
          fontSize: 15.0,
        ),
        marginDescription: EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          top: 20.0,
          bottom: 70.0,
        ),
        backgroundColor: Colors.white,
      ),
    );
  }

  void onDonePress() {
    log("onDonePress caught");
    Navigator.pushReplacementNamed(context, "/widgetTree");
  }

  void onNextPress() {
    log("onNextPress caught");
  }

  Widget renderNextBtn() {
    return const Icon(
      Icons.navigate_next_rounded,
      size: 25,
    );
  }

  Widget renderDoneBtn() {
    return const Icon(
      Icons.done_rounded,
      size: 25,
    );
  }

  Widget renderSkipBtn() {
    return const Text("Skip");
  }

  ButtonStyle myButtonStyle() {
    return ButtonStyle(
      shape: MaterialStateProperty.all<OutlinedBorder>(const StadiumBorder()),
      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      key: UniqueKey(),
      // Content config
      listContentConfig: listContentConfig,
      backgroundColorAllTabs: Colors.grey,

      // Skip button
      renderSkipBtn: renderSkipBtn(),
      skipButtonStyle: myButtonStyle(),
      skipButtonKey: const Key("skipButtonKey"),

      // Next button
      renderNextBtn: renderNextBtn(),
      onNextPress: onNextPress,
      nextButtonStyle: myButtonStyle(),
      nextButtonKey: const Key("nextButtonKey"),
      // Done button
      renderDoneBtn: renderDoneBtn(),
      onDonePress: onDonePress,
      doneButtonStyle: myButtonStyle(),
      doneButtonKey: const Key("doneButtonKey"),

      // Indicator
      indicatorConfig: IndicatorConfig(
        sizeIndicator: sizeIndicator,
        indicatorWidget: Container(
          width: sizeIndicator,
          height: 10,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: inactiveColor),
        ),
        activeIndicatorWidget: Container(
          width: sizeIndicator,
          height: 10,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: activeColor),
        ),
        spaceBetweenIndicator: 10,
        typeIndicatorAnimation: TypeIndicatorAnimation.sliding,
      ),

      // Navigation bar
      navigationBarConfig: NavigationBarConfig(
        navPosition: NavPosition.bottom,
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).viewPadding.top > 0 ? 20 : 10,
          bottom: MediaQuery.of(context).viewPadding.bottom > 0 ? 20 : 10,
        ),
      ),

      // Scroll behavior
      isAutoScroll: false,
      isLoopAutoScroll: false,
      curveScroll: Curves.bounceIn,
    );
  }
}
