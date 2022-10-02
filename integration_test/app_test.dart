import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:maneja_tus_cuentas/Screens/home/home_page.dart';
import 'package:maneja_tus_cuentas/main.dart' as app;
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('App Test', () {

    //Usuario que entra a la aplicacion
    testWidgets("login", (tester) async {
      await app.main();
      await tester.pumpAndSettle();
      var interval = const Duration(seconds: 3);
      await tester.pumpAndSettle(interval);

      // Avanzo por las landing pages
      var nextKey = find.byKey(const Key("nextButtonKey"));
      for ( var i = 0; i < 2 ; i++) {
        await tester.tap(nextKey);
        await tester.pumpAndSettle();
        await tester.pump(interval);
      }
      var doneKey = find.byKey(const Key("doneButtonKey"));
      await tester.tap(doneKey);
      await tester.pumpAndSettle();
      await tester.pump(interval);


      // ingreso mail
      var emailBox = find.byKey(const Key("emailBox") );
      await tester.enterText(emailBox, "sranucci@itba.edu.ar");
      await tester.pump();

      // ingreso contrasena
      var passwordBox = find.byKey(const Key("passwordBox"));
      await tester.pump();
      await tester.enterText(passwordBox, "ranabobo");

      // bajo teclado
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump(interval);

      // toco login
      await tester.tap(find.byKey(const Key("loginButton")));
      await tester.testTextInput.receiveAction(TextInputAction.done);

      // espero a autenticacion de firebase luego se muestra home page
      await tester.pump(const Duration(seconds: 10));

      // espero a que la base de datos de firebase me mande el nombre de usuario
      await tester.pump(interval);


      // me fijo que el nombre de usuario aparezca y sea el correcto
      expect(find.text('Rapanui'), findsOneWidget);

      // dejo que se vea la pantalla por 10 segundos
      await tester.pump(const Duration(seconds: 10));

    });
    /*flutter run -d chrome --web-port 2021 integration_test/app_test.dart
*/
    /*
    testWidgets("homePage navigation", (tester) async {
      await Firebase.initializeApp()
      var interval = const Duration(seconds: 4);
      await tester.pumpWidget(const HomePage());
      await tester.pump(interval);

    }
    );

     */

  });
}