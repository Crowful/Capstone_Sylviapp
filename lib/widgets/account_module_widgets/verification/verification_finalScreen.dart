import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VerificationFinalScreen extends StatefulWidget {
  const VerificationFinalScreen({Key? key}) : super(key: key);

  @override
  _VerificationFinalScreenState createState() =>
      _VerificationFinalScreenState();
}

class _VerificationFinalScreenState extends State<VerificationFinalScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Text(
                    "Application Submitted, wait for 3-10 days for verification of your account.",
                    style: TextStyle(
                        color: Color(0xff65BFB8),
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 40,
                  width: 100,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Color(0xff65BFB8), shape: StadiumBorder()),
                      onPressed: () {
                        Navigator.pushNamed(context, '/home');
                      },
                      child: Text("home")),
                )
              ]),
        ),
      ),
    );
  }
}
