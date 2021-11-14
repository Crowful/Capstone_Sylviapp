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
          color: Color(0xff65BFB8),
          child: Text(
              "You are already verified, please enjoy the features of being an Organizer!"),
        ),
      ),
    ));
  }
}
