import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sylviapp_project/screens/account_module/login.dart';
import 'package:sylviapp_project/screens/account_module/register.dart';
import 'package:sylviapp_project/screens/home.dart';

void main() async {
  group('Login', () {
    Widget test({required Widget child}) {
      WidgetsFlutterBinding.ensureInitialized();
      return MaterialApp(
        home: ProviderScope(
          child: child,
        ),
      );
    }

    testWidgets('Login Screen', (WidgetTester tester) async {
      // Create the widget by telling the tester to build it.

      await Firebase.initializeApp();
      await tester.pumpWidget(test(
        child: LoginScreen(),
      ));
      var textField = find.byType(TextField);
      expect(textField, findsOneWidget);
      await tester.enterText(textField, 'trtryy@gmail.com');
      print('User');
      expect(textField, findsOneWidget);
      await tester.enterText(textField, 'qwer1qwer');
      print('User');
      var button = find.text("Login");
      expect(button, findsOneWidget);
      print('Login Button');
      await tester.tap(button);
      await tester.pump();
    });
  });
}
