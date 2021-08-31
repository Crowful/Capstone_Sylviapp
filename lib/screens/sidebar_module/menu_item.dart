import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final String route;

  const MenuItem(
      {Key? key, required this.title, required this.icon, required this.route})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, route);
        },
        child: Row(
          children: [
            Icon(
              icon,
              color: Color(0xff63FF7D),
              size: 30,
            ),
            SizedBox(width: 16),
            Expanded(
                child: Text(
              title,
              style: TextStyle(fontSize: 12),
            ))
          ],
        ),
      ),
    );
  }
}
