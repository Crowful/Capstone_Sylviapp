import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sylviapp_project/widgets/account_module_widgets/register_basic_info.dart';
import 'package:sylviapp_project/widgets/account_module_widgets/register_password.dart';
import 'package:sylviapp_project/widgets/account_module_widgets/register_user_email.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final PageController registerPageController = PageController(initialPage: 0);
  int currentPage = 0;
  @override
  void initState() {
    super.initState();
    currentPage = 0;
    registerPageController.addListener(() {
      setState(() {
        currentPage = registerPageController.page!.toInt();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Create your account',
            style: GoogleFonts.sourceSansPro(
                fontWeight: FontWeight.w700, fontSize: 18),
          ),
          elevation: 0,
        ),
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          controller: registerPageController,
          children: [
            UserRegPage(
              height: height,
              width: width,
              previousButton: InkWell(
                  onTap: () {
                    registerPageController.animateToPage(
                        registerPageController.page!.toInt() - 1,
                        duration: Duration(milliseconds: 1000),
                        curve: Curves.fastOutSlowIn);
                  },
                  child: Text('Back')),
              nextButton: InkWell(
                  onTap: () {
                    registerPageController.animateToPage(
                        registerPageController.page!.toInt() + 1,
                        duration: Duration(milliseconds: 1000),
                        curve: Curves.fastOutSlowIn);
                  },
                  child: Center(child: Text('Next'))),
            ),
            PasswordRegPage(
              height: height,
              width: width,
              previousButton: currentPage == 0
                  ? SizedBox(
                      width: 0,
                    )
                  : InkWell(
                      onTap: () {
                        print(currentPage);
                        registerPageController.animateToPage(
                            registerPageController.page!.toInt() - 1,
                            duration: Duration(milliseconds: 1000),
                            curve: Curves.fastOutSlowIn);
                      },
                      child: Center(child: Text('Go Back'))),
              nextButton: InkWell(
                  onTap: () {
                    registerPageController.animateToPage(
                        registerPageController.page!.toInt() + 1,
                        duration: Duration(milliseconds: 1000),
                        curve: Curves.fastOutSlowIn);
                  },
                  child: Center(child: Text('Next'))),
            ),
            BasicInfoPage(
              height: height,
              width: width,
              previousButton: currentPage == 0
                  ? SizedBox(
                      width: 0,
                    )
                  : InkWell(
                      onTap: () {
                        print(currentPage);
                        registerPageController.animateToPage(
                            registerPageController.page!.toInt() - 1,
                            duration: Duration(milliseconds: 1000),
                            curve: Curves.fastOutSlowIn);
                      },
                      child: Center(child: Text('Go Back'))),
              nextButton: InkWell(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, "/onboarding");
                  },
                  child: Center(child: Text('Next'))),
            )
          ],
        ));
  }
}
