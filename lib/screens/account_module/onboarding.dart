import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentPage = 0;
  final PageController _onboardingController = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                      onTap: () {},
                      child: Text(
                        'Skip',
                        style: GoogleFonts.openSans(color: Colors.black),
                      ))),
              Container(
                  height: 600,
                  width: width,
                  child: PageView(
                    physics: ClampingScrollPhysics(),
                    controller: _onboardingController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: [
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Center(
                              child: Column(
                                children: [
                                  Text(
                                    'Onboarding 1',
                                    style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff403d55),
                                        fontSize: 21),
                                  ),
                                  Image(
                                    image: AssetImage(
                                        'assets/images/onboarding.png'),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
