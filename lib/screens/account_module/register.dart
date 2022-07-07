import 'package:flutter/material.dart';
import 'package:sylviapp_project/Domain/aes_cryptography.dart';
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
  void dispose() {
    registerPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          controller: registerPageController,
          children: [
            UserRegPage(
              height: height,
              width: width,
              previousButton: GestureDetector(
                  onTap: () {
                    registerPageController.animateToPage(
                        registerPageController.page!.toInt() - 1,
                        duration: Duration(milliseconds: 1000),
                        curve: Curves.fastOutSlowIn);
                  },
                  child: Icon(Icons.arrow_back_ios, color: Colors.white)),
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
                  : GestureDetector(
                      onTap: () {
                        registerPageController.animateToPage(
                            registerPageController.page!.toInt() - 1,
                            duration: Duration(milliseconds: 1000),
                            curve: Curves.fastOutSlowIn);
                      },
                      child: Icon(Icons.arrow_back_ios, color: Colors.white)),
              nextButton: InkWell(
                  onTap: () {
                    registerPageController.animateToPage(
                        registerPageController.page!.toInt() + 1,
                        duration: Duration(milliseconds: 1000),
                        curve: Curves.fastOutSlowIn);

                    print(context.read(userAccountProvider).getEmail);
                    print(context.read(userAccountProvider).getPassword);
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
            BasicInfoPage(
              height: height,
              width: width,
              previousButton: currentPage == 0
                  ? SizedBox(
                      width: 0,
                    )
                  : GestureDetector(
                      onTap: () {
                        registerPageController.animateToPage(
                            registerPageController.page!.toInt() - 1,
                            duration: Duration(milliseconds: 1000),
                            curve: Curves.fastOutSlowIn);
                      },
                      child: Icon(Icons.arrow_back_ios, color: Colors.white)),
              nextButton: InkWell(
                  onTap: () {
                    context
                        .read(authserviceProvider)
                        .signUp(
                            context.read(userAccountProvider).getEmail,
                            context.read(userAccountProvider).getPassword,
                            AESCryptography().encryptAES(
                                context.read(userAccountProvider).getFullname),
                            AESCryptography().encryptAES(
                                context.read(userAccountProvider).getAddress),
                            AESCryptography().encryptAES(
                                context.read(userAccountProvider).getGender),
                            AESCryptography().encryptAES(
                                context.read(userAccountProvider).getContact),
                            AESCryptography().encryptAES(
                                context.read(userAccountProvider).getUserName),
                            context)
                        .whenComplete(() => Navigator.pushNamed(
                            context, "/wrapperCatchSignup"));
                  },
                  child: Center(
                      child: Text(
                    'Next',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ))),
            )
          ],
        ));
  }
}
