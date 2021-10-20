import 'package:flutter/material.dart';

class StatusRoleScreen extends StatefulWidget {
  const StatusRoleScreen({Key? key}) : super(key: key);

  @override
  _StatusRoleScreenState createState() => _StatusRoleScreenState();
}

class _StatusRoleScreenState extends State<StatusRoleScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: Container(
          child:
              Text("CONGRATS YOU'RE ALREADY AN ORGANIZER! CREATE A CAMPAIGN"),
        ),
      ),
    ));
  }
}
