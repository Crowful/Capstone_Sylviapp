import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sylviapp_project/screens/account_module/login.dart';
import 'package:sylviapp_project/screens/home.dart';

void main() {
  group('Home', () {
    Widget test({required Widget child}) {
      WidgetsFlutterBinding.ensureInitialized();
      Firebase.initializeApp();
      return MaterialApp(
        home: ProviderScope(
          child: child,
        ),
      );
    }

    testWidgets('Homescreen', (WidgetTester tester) async {
      // Create the widget by telling the tester to build it.

      await tester.pumpWidget(test(
        child: HomePage(
          controller: AnimationController(
              duration: Duration(milliseconds: 500), vsync: TestVSync()),
          duration: Duration(milliseconds: 500),
        ),
      ));
      await tester.pumpAndSettle();
    });
  });
}
