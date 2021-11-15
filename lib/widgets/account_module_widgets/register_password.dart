import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sylviapp_project/providers/providers.dart';

class PasswordRegPage extends StatefulWidget {
  final double height;
  final double width;
  final Widget nextButton;
  final Widget previousButton;
  const PasswordRegPage(
      {Key? key,
      required this.height,
      required this.width,
      required this.nextButton,
      required this.previousButton})
      : super(key: key);
  @override
  _PasswordRegPageState createState() => _PasswordRegPageState();
}

class _PasswordRegPageState extends State<PasswordRegPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController =
      AnimationController(vsync: this, duration: const Duration(seconds: 2))
        ..repeat(reverse: true);

  late AnimationController _widgetController =
      AnimationController(vsync: this, duration: Duration(seconds: 1));

  //TextControllers and Validation
  final TextEditingController _primaryPaswword = TextEditingController();

  final TextEditingController _confirmPassword = TextEditingController();

  final userName = "";

  bool _isVisible = false;

  bool _isPasswordEightCharacters = false;

  bool _hasPasswordOneNumber = false;

  bool _isMatch = false;

  bool _isVisibleCP = false;

  bool _overall = false;

  //INIT STATE and DISPOSE
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 3))
          ..repeat(reverse: true);
    _widgetController.forward();
  }

  onValidate() {
    setState(() {
      _overall = false;
      if (_isMatch == true &&
          _hasPasswordOneNumber == true &&
          _isPasswordEightCharacters == true) {
        _overall = true;

        context.read(userAccountProvider).setPassword(_primaryPaswword.text);
      }
    });
  }

  onPasswordChanged(String password) {
    final numericRegex = RegExp(r'[0-9]');

    setState(() {
      _isPasswordEightCharacters = false;
      if (password.length >= 8) {
        _isPasswordEightCharacters = true;
        onValidate();
      }
      _hasPasswordOneNumber = false;
      if (numericRegex.hasMatch(password)) {
        _hasPasswordOneNumber = true;
        onValidate();
      }
    });
  }

  onConfirmPasswordChange(String password) {
    setState(() {
      _isMatch = false;
      if (_confirmPassword.text == _primaryPaswword.text) {
        _isMatch = true;
        onValidate();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
            height: size.height,
            width: size.width,
            color: Color(0xff65BFB8),
            child: Stack(children: [
              Align(
                  alignment: Alignment.bottomCenter,
                  child: FadeTransition(
                    opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                            parent: _widgetController,
                            curve: Interval(0.1, 1.0, curve: Curves.easeIn))),
                    child: Container(
                      height: 300,
                      width: size.width,
                      decoration: BoxDecoration(
                          color: null,
                          image: DecorationImage(
                              image: AssetImage("assets/images/userpass.png"),
                              fit: BoxFit.cover)),
                    ),
                  )),
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, "/login");
                            },
                            child: Icon(Icons.arrow_back_ios,
                                color: Colors.white)),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Create your account',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 120,
                  ),
                  Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          FadeTransition(
                            opacity: Tween<double>(begin: 0.0, end: 1.0)
                                .animate(CurvedAnimation(
                                    parent: _widgetController,
                                    curve: Interval(0.2, 1.0,
                                        curve: Curves.easeIn))),
                            child: Text(
                              'Set your password!',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff2b2b2b)),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          FadeTransition(
                            opacity: Tween<double>(begin: 0.0, end: 1.0)
                                .animate(CurvedAnimation(
                                    parent: _widgetController,
                                    curve: Interval(0.2, 1.0,
                                        curve: Curves.easeIn))),
                            child: SlideTransition(
                              position: Tween<Offset>(
                                      begin: Offset(0, -0.5), end: Offset.zero)
                                  .animate(CurvedAnimation(
                                      parent: _widgetController,
                                      curve: Curves.easeIn)),
                              child: Text(
                                  'Enter your desired password, it must have enough complexity to protect your own information.',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color:
                                          Color(0xff3b3b3b).withOpacity(0.8))),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          FadeTransition(
                            opacity: Tween<double>(begin: 0.0, end: 1.0)
                                .animate(CurvedAnimation(
                                    parent: _widgetController,
                                    curve: Interval(0.2, 1.0,
                                        curve: Curves.easeIn))),
                            child: SlideTransition(
                              position: Tween<Offset>(
                                      begin: Offset(0, -0.5), end: Offset.zero)
                                  .animate(CurvedAnimation(
                                      parent: _widgetController,
                                      curve: Interval(0.7, 1,
                                          curve: Curves.easeIn))),
                              child: Row(
                                children: [
                                  AnimatedContainer(
                                    duration: Duration(milliseconds: 500),
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        color: _isPasswordEightCharacters
                                            ? Color(0xff2b2b2b)
                                            : Colors.transparent,
                                        border: _isPasswordEightCharacters
                                            ? Border.all(
                                                color: Colors.transparent)
                                            : Border.all(
                                                color: Color(0xff2b2b2b)),
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: Center(
                                      child: Icon(
                                        Icons.check,
                                        color: _isPasswordEightCharacters
                                            ? Colors.white
                                            : Color(0xff2b2b2b),
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("Contains at least 8 characters")
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          FadeTransition(
                            opacity: Tween<double>(begin: 0.0, end: 1.0)
                                .animate(CurvedAnimation(
                                    parent: _widgetController,
                                    curve: Interval(0.2, 1.0,
                                        curve: Curves.easeIn))),
                            child: SlideTransition(
                              position: Tween<Offset>(
                                      begin: Offset(0, -0.5), end: Offset.zero)
                                  .animate(CurvedAnimation(
                                      parent: _widgetController,
                                      curve: Interval(0.7, 1,
                                          curve: Curves.easeIn))),
                              child: Row(children: [
                                AnimatedContainer(
                                  duration: Duration(milliseconds: 500),
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                      color: _hasPasswordOneNumber
                                          ? Color(0xff2b2b2b)
                                          : Colors.transparent,
                                      border: _hasPasswordOneNumber
                                          ? Border.all(
                                              color: Colors.transparent)
                                          : Border.all(
                                              color: Color(0xff2b2b2b)),
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Center(
                                    child: Icon(
                                      Icons.check,
                                      color: _hasPasswordOneNumber
                                          ? Colors.white
                                          : Color(0xff2b2b2b),
                                      size: 15,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("Contains at least 1 number"),
                              ]),
                            ),
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              FadeTransition(
                                opacity: Tween<double>(begin: 0.0, end: 1.0)
                                    .animate(CurvedAnimation(
                                        parent: _widgetController,
                                        curve: Interval(0.2, 1.0,
                                            curve: Curves.easeIn))),
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                          begin: Offset(0, -0.5),
                                          end: Offset.zero)
                                      .animate(CurvedAnimation(
                                          parent: _widgetController,
                                          curve: Interval(0.7, 1,
                                              curve: Curves.easeIn))),
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 500),
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        color: _isMatch
                                            ? Color(0xff2b2b2b)
                                            : Colors.transparent,
                                        border: _isMatch
                                            ? Border.all(
                                                color: Colors.transparent)
                                            : Border.all(
                                                color: Color(0xff2b2b2b)),
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: Center(
                                      child: Icon(
                                        Icons.check,
                                        color: _overall
                                            ? Colors.white
                                            : Color(0xff2b2b2b),
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Password Matched"),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 2,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15))),
                            width: double.infinity,
                            child: TextField(
                              obscureText: !_isVisible,
                              controller: _primaryPaswword,
                              onChanged: (password) =>
                                  {onPasswordChanged(password)},
                              decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _isVisible = !_isVisible;
                                      });
                                    },
                                    icon: _isVisibleCP
                                        ? Icon(
                                            Icons.visibility,
                                            color: Colors.black,
                                          )
                                        : Icon(
                                            Icons.visibility_off,
                                            color: Colors.grey,
                                          ),
                                  ),
                                  focusColor: Colors.white,
                                  labelText: "Password",
                                  prefixIcon: Icon(Icons.password),
                                  contentPadding: EdgeInsets.all(15),
                                  border: InputBorder.none),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 2,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15))),
                            width: double.infinity,
                            child: TextField(
                              obscureText: !_isVisibleCP,
                              controller: _confirmPassword,
                              onChanged: (password) =>
                                  onConfirmPasswordChange(password),
                              decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _isVisibleCP = !_isVisibleCP;
                                      });
                                    },
                                    icon: _isVisibleCP
                                        ? Icon(
                                            Icons.visibility,
                                            color: Colors.black,
                                          )
                                        : Icon(
                                            Icons.visibility_off,
                                            color: Colors.grey,
                                          ),
                                  ),
                                  focusColor: Colors.white,
                                  labelText: "Confirm Password",
                                  prefixIcon: Icon(Icons.password),
                                  contentPadding: EdgeInsets.all(15),
                                  border: InputBorder.none),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Align(
                              alignment: Alignment.bottomRight,
                              child: AbsorbPointer(
                                absorbing: _overall ? false : true,
                                child: AnimatedContainer(
                                    curve: Curves.fastOutSlowIn,
                                    duration:
                                        const Duration(milliseconds: 1000),
                                    height: 40,
                                    width: _overall ? 500 : 90,
                                    decoration: BoxDecoration(
                                        color: _overall
                                            ? Color(0xff3b3b3b)
                                            : Color(0xff3b3b3b)
                                                .withOpacity(0.5),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Center(child: widget.nextButton)),
                              ))
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
