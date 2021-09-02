import 'dart:async';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  bool after = false;
  double opacityLevel = 0;
  double targetValue = 0;
  bool animated = false;

  late Timer _timer;
  WelcomeScreenState() {
    animated = false;
    _timer = new Timer(const Duration(milliseconds: 500), () {
      setState(() {
        animated = true;
        targetValue = 5;
        if (animated == true) {
          _timer = new Timer(const Duration(milliseconds: 200), () {
            setState(() {
              after = true;
            });
          });
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        AnimatedContainer(
          duration: Duration(seconds: 3),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/first_screen.jpg"),
                  fit: BoxFit.cover)),
          curve: Curves.fastOutSlowIn,
          child: TweenAnimationBuilder<double>(
            curve: Curves.fastOutSlowIn,
            tween: Tween<double>(begin: 0.0, end: targetValue),
            duration: const Duration(milliseconds: 300),
            builder: (_, value, child) {
              return ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: value, sigmaY: value),
                  child: Container(
                    color: Colors.white.withOpacity(0),
                  ),
                ),
              );
            },
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Container(
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: AnimatedDefaultTextStyle(
                curve: Curves.fastOutSlowIn,
                style: animated
                    ? GoogleFonts.roboto(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 70)
                    : GoogleFonts.roboto(
                        color: Color(0xff00a3a5).withOpacity(0),
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                duration: Duration(milliseconds: 300),
                child: Text('SYLVIAPP'),
              ),
            ),
          ),
        ),
        AnimatedPositioned(
          curve: Curves.fastOutSlowIn,
          top: after ? 650 : 850,
          duration: Duration(milliseconds: 300),
          child: Container(
              padding: EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                          decoration: BoxDecoration(
                              color: Color(0xff2f3838),
                              borderRadius: BorderRadius.circular(5)),
                          height: 70,
                          width: double.infinity,
                          child: InkWell(
                            onTap: () {},
                            child: Center(
                              child: Text(
                                'Sign-up',
                                style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontSize: 16),
                              ),
                            ),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(5)),
                          height: 70,
                          width: double.infinity,
                          child: InkWell(
                            onTap: () {},
                            child: Center(
                              child: Text(
                                'Log-in',
                                style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    fontSize: 16),
                              ),
                            ),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  )
                ],
              )),
        ),
      ]),
    );
  }
}
