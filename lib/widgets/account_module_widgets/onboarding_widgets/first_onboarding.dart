import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FirstOnboarding extends StatefulWidget {
  const FirstOnboarding({Key? key}) : super(key: key);

  @override
  FirstonboardingState createState() => FirstonboardingState();
}

class FirstonboardingState extends State<FirstOnboarding> {
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
                    'What is Sylviapp?',
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/onboarding.png"))),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Focused on Reforestation',
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
                        'Is a system to allow the creation of reforestation campaigns for local communities.',
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
