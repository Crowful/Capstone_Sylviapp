import 'package:flutter/material.dart';
import 'package:sylviapp_project/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({Key? key}) : super(key: key);

  @override
  _VerifyEmailState createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 200, 0, 0),
          child: Column(
            children: [
              Text("AN EMAIL VERFICATION HAS BEEN SENT TO YOUR EMAIL"),
              Text(
                  "Please Check your email for verification before logging in"),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/login");
                    context.read(authserviceProvider).signOut();
                  },
                  child: Text("Go Login"))
            ],
          ),
        ),
      ),
    );
  }
}
