import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
// TODO 5: Import the app that you want to test
import 'package:maneja_tus_cuentas/main.dart' as app;

void main() {
  group('App Test', () {
    // TODO 3: Add the IntegrationTestWidgetsFlutterBinding and .ensureInitialized
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    // TODO 4: Create your test case
    //test de integracion usa testeos de widget
    //IMportante, la primera vez corremos main, luego el metodo
    testWidgets("full app test", (tester) async {
      //me aseguro que el flutter driver este prendido, ejecuta un comando tras otro
      await app.main();
      await tester.pumpAndSettle();// me aseguro que no se actualizan elementos de la UI

      // TODO 6: execute the app.main() function
      // TODO 7: Wait until the app has settled


      var nextKey = find.byKey(const Key("skipButtonKey"));
      await tester.tap(nextKey);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 10));
      // TODO 8: create finders for email, password and login
      // TODO 9: Enter text for the email address
      // TODO 10: Enter text for the password
      // TODO 11: Tap on the login button and wait till it settled
      // TODO 12: Find the first checkbox in the screen
      // TODO 13: Check the semantics of the checkbox if it is not checked
      // TODO 13: Tap on the checkbox and wait till it settled
      // TODO 14: Expect the result to be checked
    });
  });
}