import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/src/provider.dart';
import 'package:sylviapp_project/providers/providers.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late AnimationController _animateController =
      AnimationController(vsync: this, duration: Duration(seconds: 3))
        ..repeat(reverse: true);

  late AnimationController _widgetController =
      AnimationController(vsync: this, duration: Duration(seconds: 2));
  late Animation<Offset> _animation = Tween<Offset>(
    begin: Offset.zero,
    end: Offset(0, 0.08),
  ).animate(_animateController);

  late Animation<Offset> _widgetTransition =
      Tween<Offset>(begin: Offset(0, -0.5), end: Offset.zero)
          .animate(_widgetController);

  @override
  void initState() {
    super.initState();
    _animateController =
        AnimationController(vsync: this, duration: Duration(seconds: 3))
          ..repeat(reverse: true);

    _widgetController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));

    _widgetController.forward();
  }

  @override
  void dispose() {
    _widgetController.dispose();
    super.dispose();
  }

  final TextEditingController _etEmailController = TextEditingController();
  final TextEditingController _etPasswordController = TextEditingController();
  final GlobalKey<FormState> _formLogin = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _widgetController.forward();
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
      child: Form(
        key: _formLogin,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: size.height * 0.2,
                top: size.height * 0.05),
            color: Color(0xff65BFB8),
            width: size.width,
            height: size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SlideTransition(
                  position: _animation,
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/login.png"),
                            fit: BoxFit.cover)),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    FadeTransition(
                      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: _widgetController,
                              curve: Interval(0.1, 1.0, curve: Curves.easeIn))),
                      child: SlideTransition(
                        position: _widgetTransition,
                        child: Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    FadeTransition(
                      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: _widgetController,
                              curve: Interval(0.2, 1.0, curve: Curves.easeIn))),
                      child: SlideTransition(
                        position: _widgetTransition,
                        child: Text(
                          'Welcome to Sylviapp',
                          style: TextStyle(fontSize: 18, color: Colors.black54),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
                FadeTransition(
                  opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                          parent: _widgetController,
                          curve: Interval(0.2, 1.0, curve: Curves.easeIn))),
                  child: SlideTransition(
                    position: _widgetTransition,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15))),
                          width: double.infinity,
                          child: TextField(
                            controller: _etEmailController,
                            onChanged: (email) => {},
                            decoration: InputDecoration(
                                focusColor: Color(0xff65BFB8),
                                labelText: "Email",
                                hintText: "email@mail.com",
                                prefixIcon: Icon(Icons.email),
                                contentPadding: EdgeInsets.all(15),
                                border: InputBorder.none),
                          ),
                        ),
                        Divider(
                          height: 0.5,
                          color: Colors.black,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: Offset(0, 5),
                                ),
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15))),
                          width: double.infinity,
                          child: TextField(
                            controller: _etPasswordController,
                            onChanged: (email) => {},
                            decoration: InputDecoration(
                                focusColor: Colors.white,
                                labelText: "Password",
                                hintText: "Password",
                                prefixIcon: Icon(Icons.vpn_key),
                                contentPadding: EdgeInsets.all(15),
                                border: InputBorder.none),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                FadeTransition(
                  opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                          parent: _widgetController,
                          curve: Interval(0.6, 1.0, curve: Curves.easeIn))),
                  child: SlideTransition(
                    position: _widgetTransition,
                    child: Align(
                      alignment: Alignment.center,
                      child: RichText(
                          text: TextSpan(
                              text: 'Don\'t have an account?',
                              children: [
                            TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushNamed(context, "/register");
                                  },
                                text: ' Register here.',
                                style: TextStyle(
                                    color: Color(0xff2b2b2b),
                                    fontWeight: FontWeight.w500)),
                          ])),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                GestureDetector(
                  onTap: () {
                    context
                        .read(authserviceProvider)
                        .signIn(
                            _etEmailController.text, _etPasswordController.text)
                        .whenComplete(
                            () => Navigator.pushNamed(context, "/wrapperAuth"));
                  },
                  child: FadeTransition(
                    opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                            parent: _widgetController,
                            curve: Interval(0.1, 1.0, curve: Curves.easeIn))),
                    child: Align(
                      alignment: Alignment.center,
                      child: SlideTransition(
                        position: Tween<Offset>(
                                begin: Offset(0, -0.5), end: Offset.zero)
                            .animate(CurvedAnimation(
                                parent: _widgetController,
                                curve: Interval(0.5, 1.0,
                                    curve: Curves.fastOutSlowIn))),
                        child: Container(
                          child: Center(
                            child: Text(
                              'Login',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          height: 50,
                          width: 150,
                          decoration: BoxDecoration(
                              color: Color(0xff2b2b2b),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
