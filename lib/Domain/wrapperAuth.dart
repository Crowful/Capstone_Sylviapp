import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sylviapp_project/providers/providers.dart';

class WrapperAuth extends ConsumerWidget {
  const WrapperAuth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, watch) {
    final firebaseUser = watch(authserviceProvider);

    if (firebaseUser != null && firebaseUser.userVerified == true) {
      // return the Condition for role
    } else if (firebaseUser != null && firebaseUser.userVerified == false) {
      // return the email verification screen
    }
    //return log in screen
    return (Text("Log in"));
  }
}
