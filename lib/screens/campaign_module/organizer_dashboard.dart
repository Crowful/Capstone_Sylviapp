import 'package:flutter/material.dart';

class OrganizerDashBoard extends StatefulWidget {
  const OrganizerDashBoard({Key? key}) : super(key: key);

  @override
  _OrganizerDashBoardState createState() => _OrganizerDashBoardState();
}

class _OrganizerDashBoardState extends State<OrganizerDashBoard> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Text("ORGANIZER SCREEN"),
      ),
    );
  }
}
