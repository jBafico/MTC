// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maneja_tus_cuentas/Screens/Components/Cards/card.dart';
import 'package:maneja_tus_cuentas/Screens/authentication/login.dart';
import 'package:maneja_tus_cuentas/Screens/home/home_page.dart';
import 'package:maneja_tus_cuentas/firebase_options.dart';

import 'package:maneja_tus_cuentas/main.dart';



void main() {



    testWidgets("testing homePage widget", (tester) async {


        await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
        var emailBox = find.byKey(const Key("emailBox") );
        await tester.enterText(emailBox, "sranucci@itba.edu.ar");
        await tester.pump();

        expect(find.text("sranucci@itba.edu.ar"), findsOneWidget);


    });

}

