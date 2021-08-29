import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sylviapp_project/widgets/account_module_widgets/onboarding_widgets/first_onboarding.dart';

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

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Color(0xFF7B51D3),
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
          padding: EdgeInsets.symmetric(vertical: 40.0),
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
                    children: [FirstOnboarding()],
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildPageIndicator(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
