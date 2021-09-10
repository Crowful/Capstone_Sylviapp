import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sylviapp_project/Domain/wrapperRole.dart';
import 'package:sylviapp_project/providers/providers.dart';
import 'package:sylviapp_project/screens/account_module/login.dart';
import 'package:sylviapp_project/screens/account_module/onboarding.dart';
import 'package:sylviapp_project/screens/account_module/verify_email.dart';
import 'package:sylviapp_project/screens/home.dart';
import 'package:sylviapp_project/screens/layout_screen.dart';

class WrapperAuth extends ConsumerWidget {
  const WrapperAuth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, watch) {
    final firebaseUser = watch(authStateProvider);

    return firebaseUser.when(
        data: (user) {
          if (user != null && user.emailVerified == true) {
            return LayoutScreen();
          } else if (user != null && user.emailVerified == false) {
            return VerifyEmail();
          } else {
            return LoginScreen();
          }
        },
        loading: () => CircularProgressIndicator(),
        error: (error, trace) => Text("something went wrong"));
  }
}
