import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sylviapp_project/animations/route_transitions.dart';
import 'package:sylviapp_project/screens/home.dart';
import 'package:sylviapp_project/widgets/account_module_widgets/onboarding_widgets/first_onboarding.dart';
import 'package:sylviapp_project/widgets/account_module_widgets/onboarding_widgets/second_onboarding.dart';
import 'package:sylviapp_project/widgets/account_module_widgets/onboarding_widgets/third_onboarding.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final int _numPages = 3;
  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }
  //Transistio

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color:
            isActive ? Color(0xff403d55) : Color(0xff403d55).withOpacity(0.5),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  int _currentPage = 0;
  final PageController _onboardingController = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        child: Padding(
          padding: EdgeInsets.only(top: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                        onTap: () {},
                        child: Text(
                          'Skip',
                          style: GoogleFonts.openSans(
                              color: Color(0xff403d55),
                              fontWeight: FontWeight.w600),
                        ))),
              ),
              Container(
                  height: height / 1.3,
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
                      FirstOnboarding(),
                      SecondOnboarding(),
                      ThirdOnboarding()
                    ],
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildPageIndicator(),
              ),
              SizedBox(
                height: 80,
              ),
              _currentPage != _numPages - 1
                  ? Expanded(
                      child: Align(
                        alignment: FractionalOffset.bottomRight,
                        child: InkWell(
                          onTap: () {
                            _onboardingController.nextPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.fastOutSlowIn,
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Next'),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.black,
                                size: 25,
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  : Expanded(
                      child: Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: Container(
                          height: 100,
                          width: double.infinity,
                          color: Color(0xff403d55),
                          child: Align(
                              alignment: Alignment.center,
                              child: InkWell(
                                onTap: () {
                                  // Navigator.pushNamed(context, Home);
                                },
                                child: Text(
                                  'Get Started',
                                  style: GoogleFonts.roboto(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400),
                                ),
                              )),
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
