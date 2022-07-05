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
                    'What we can provide to the users...',
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.bold, fontSize: 23),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image:
                                AssetImage("assets/images/onboarding2.png"))),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'What is our features?',
                      style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: Color(0xff65BFB8)),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        'Donation model to fund reforestation campaigns for local communities.\nVisualize the reforestation activities and accomplishments.',
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
