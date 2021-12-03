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
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(20),
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.forward_to_inbox,
                size: 80,
                color: Color(0xff65BFB8),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Email Verification Sent!",
                    style: TextStyle(
                        color: Color(0xff65BFB8),
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Please check your email for verification to access Sylviapp.",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/login");
                  context.read(authserviceProvider).signOut();
                },
                child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                        color: Color(0xff65BFB8),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Center(child: Text("Go Login"))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
