import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sylviapp_project/providers/providers.dart';
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
              child: Center(
                  child: Text(
                'Next',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ))),
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

                print(context.read(userAccountProvider).getEmail);
                print(context.read(userAccountProvider).getPassword);
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
                context
                    .read(authserviceProvider)
                    .signUp(
                      context.read(userAccountProvider).getEmail,
                      context.read(userAccountProvider).getPassword,
                      context.read(userAccountProvider).getFullname,
                      context.read(userAccountProvider).getAddress,
                      context.read(userAccountProvider).getGender,
                      context.read(userAccountProvider).getContact,
                      context.read(userAccountProvider).getUserName,
                    )
                    .whenComplete(
                        () => Navigator.pushNamed(context, "/onboarding"));
              },
              child: Center(child: Text('Next'))),
        )
      ],
    ));
  }
}
