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
      await Firebase.initializeApp();
      await tester.pumpWidget(test(
        child: LoginScreen(),
      ));
      var email = find.byType(TextField);
      var password = find.byType(TextField);
      expect(email, findsOneWidget);
      await tester.enterText(email, 'trtryy@gmail.com');
      print('email');
      expect(password, findsOneWidget);
      await tester.enterText(password, 'qwer1qwer');
      print('pass');
      var button = find.text("Login");
      expect(button, findsOneWidget);
      print('Login Button');
      await tester.tap(button);
      await tester.pump();
    });
  });
}
