import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sylviapp_project/providers/providers.dart';
import 'package:sylviapp_project/screens/account_module/onboarding.dart';
import 'package:sylviapp_project/screens/account_module/register.dart';

class SignupDomain extends ConsumerWidget {
  const SignupDomain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, watch) {
    final firebaseUser = watch(authStateProvider);

    return firebaseUser.when(
        data: (user) {
          if (user != null) {
            return OnboardingScreen();
          } else {
            return RegisterPage();
          }
        },
        loading: () => CircularProgressIndicator(),
        error: (error, trace) => Text("something went wrong"));
  }
}
