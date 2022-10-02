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


      var emailBox = find.byKey(const Key("emailBox") );
      await tester.enterText(emailBox, "sranucci@itba.edu.ar");
      await tester.pump();
      var passwordBox = find.byKey(const Key("passwordBox"));
      await tester.pump();
      await tester.enterText(passwordBox, "ranabobo");
      await tester.pump();
      await tester.tap(find.byKey(const Key("loginButton")));
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump(const Duration(seconds: 10));
      //await tester.pumpWidget(const MaterialApp(home: HomePage(),));


      await tester.pump(const Duration(seconds: 30));

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