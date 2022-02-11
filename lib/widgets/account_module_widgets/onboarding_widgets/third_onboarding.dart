import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThirdOnboarding extends StatefulWidget {
  const ThirdOnboarding({Key? key}) : super(key: key);

  @override
  _ThirdOnboardingState createState() => _ThirdOnboardingState();
}

class _ThirdOnboardingState extends State<ThirdOnboarding> {
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
                    'That\' all! ',
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image:
                                AssetImage("assets/images/onboarding3.png"))),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Now let\'s dive in to Sylviapp!',
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
                        'Enjoy and help each other to facilitate reforestation campaigns.',
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
