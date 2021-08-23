import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Container(
        height: height,
        width: width,
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "/register");
                },
                child: Text('Register')),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/settings");
                },
                child: Text('Settings')),
          ],
        ),
      ),
    );
  }
}
