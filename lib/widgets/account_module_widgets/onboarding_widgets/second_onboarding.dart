import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SecondOnboarding extends StatefulWidget {
  const SecondOnboarding({Key? key}) : super(key: key);

  @override
  _SecondOnboardingState createState() => _SecondOnboardingState();
}

class _SecondOnboardingState extends State<SecondOnboarding> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
            child: Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text(
                    'Onboarding 2',
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.bold,
                        color: Color(0xff403d55),
                        fontSize: 25),
                  ),
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image:
                                AssetImage("assets/images/onboarding2.png"))),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Get a new experience\nof sensation',
                      style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: Color(0xff403d55)),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        'Lorem ipsum dolor sit amet, consect adipiscing elit, sed do eiusmod tempor incididunt ut labore et.',
                        style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w500, fontSize: 17)),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}