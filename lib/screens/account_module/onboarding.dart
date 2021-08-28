import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Align(
                  alignment: Alignment.topRight,
                  child: InkWell(onTap: () {}, child: Text('Skip'))),
              PageView()
            ],
          ),
        ),
      ),
    );
  }
}
