import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:maneja_tus_cuentas/main.dart' as app;

void main() {
  group('App Test', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();


    //LOGIN TEST
    //test de integracion usa testeos de widget
    //IMportante, la primera vez corremos main, luego el metodo
    testWidgets("full app test", (tester) async {
      //me aseguro que el flutter driver este prendido, ejecuta un comando tras otro
      await app.main();
      await tester.pumpAndSettle();// me aseguro que no se actualizan elementos de la UI
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
      /*
      var emailBox = find.byKey(const Key("emailBox") );
      await tester.tap(emailBox);
      await tester.enterText(emailBox, "sranucci@itba.edu.ar");
      var passwordBox = find.byKey(const Key("passwordBox"));
      await tester.tap(passwordBox);
      await tester.enterText(passwordBox, "ranabobo");
      await tester.press(find.byKey(const Key("loginButton")));
      await tester.pump(interval);
       */
    });
  });
}