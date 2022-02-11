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
      body: Container(
        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Color(0xff65BFB8),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Color(0xff403d55),
              ),
              Text(
                'Sylviapp',
                style: TextStyle(
                    color: Color(0xff65BFB8),
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(Icons.bookmark_outline),
                onPressed: () {},
                color: Colors.transparent,
              ),
            ]),
            Align(
              alignment: Alignment.center,
              child: Text(
                "You are already verified, please enjoy the features of being an Organizer! ✔️",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.bookmark_outline),
              onPressed: () {},
              color: Colors.transparent,
            ),
          ],
        ),
      ),
    ));
  }
}
