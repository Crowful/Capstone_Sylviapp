import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sylviapp_project/providers/providers.dart';

class UserRegPage extends StatefulWidget {
  final double height;
  final double width;
  final Widget nextButton;
  final Widget previousButton;
  final Color? disableButton;
  final Color? activeButton;

  const UserRegPage(
      {Key? key,
      required this.height,
      required this.width,
      required this.nextButton,
      this.disableButton,
      this.activeButton,
      required this.previousButton})
      : super(key: key);

  @override
  _UserRegPageState createState() => _UserRegPageState();
}

class _UserRegPageState extends State<UserRegPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController =
      AnimationController(vsync: this, duration: const Duration(seconds: 2))
        ..repeat(reverse: true);

  late AnimationController _widgetController =
      AnimationController(vsync: this, duration: Duration(seconds: 1));

  //Text controllers and onchange
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _isUserFourCharacters = false;
  bool _isValidEmail = false;
  Color active = Colors.grey;
  bool overall = false;

  onValidate() {
    setState(() {
      overall = false;
      if (_isValidEmail == true && _isUserFourCharacters == true) {
        overall = true;
        context.read(userAccountProvider).setEmail(_emailController.text);
        context.read(userAccountProvider).setUserName(_usernameController.text);
      }
    });
  }

  onUserChanged(String user) {
    setState(() {
      _isUserFourCharacters = false;
      if (user.length >= 4) {
        _isUserFourCharacters = true;
        onValidate();
      }
    });
  }

  onEmailChanged(String email) {
    final charRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9]+@[a-zA-Z0-9]+[.]+[com]+");
    setState(() {
      _isValidEmail = false;
      if (charRegex.hasMatch(email)) _isValidEmail = true;
      onValidate();
    });
  }

  //INIT STATE and DISPOSE
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 3))
          ..repeat(reverse: true);
    _widgetController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
                      height: 400,
                      width: size.width,
                      decoration: BoxDecoration(
                          color: null,
                          image: DecorationImage(
                              image: AssetImage("assets/images/userrreg.png"),
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
                              'Setup your email and username',
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
                                  'Enter your username and e-mail that you will be using in our beloved application Sylviapp!',
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
                                        color: _isUserFourCharacters
                                            ? Color(0xff2b2b2b)
                                            : Colors.transparent,
                                        border: _isUserFourCharacters
                                            ? Border.all(
                                                color: Colors.transparent)
                                            : Border.all(
                                                color: Color(0xff2b2b2b)),
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: Center(
                                      child: Icon(
                                        Icons.check,
                                        color: _isUserFourCharacters
                                            ? Colors.white
                                            : Color(0xff2b2b2b),
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Contains at least 4 characters",
                                    style: TextStyle(
                                        color: _isUserFourCharacters
                                            ? Color(0xff2b2b2b)
                                            : Colors.white),
                                  )
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
                              child: Row(
                                children: [
                                  AnimatedContainer(
                                    duration: Duration(milliseconds: 500),
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        color: _isValidEmail
                                            ? Color(0xff2b2b2b)
                                            : Colors.transparent,
                                        border: _isValidEmail
                                            ? Border.all(
                                                color: Colors.transparent)
                                            : Border.all(
                                                color: Color(0xff2b2b2b)),
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: Center(
                                      child: Icon(
                                        Icons.check,
                                        color: _isValidEmail
                                            ? Colors.white
                                            : Color(0xff2b2b2b),
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("Valid Email",
                                      style: TextStyle(
                                          color: _isValidEmail
                                              ? Color(0xff2b2b2b)
                                              : Colors.white))
                                ],
                              ),
                            ),
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
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(15)
                              ],
                              controller: _usernameController,
                              onChanged: (user) => {onUserChanged(user)},
                              decoration: InputDecoration(
                                  focusColor: Colors.white,
                                  labelText: "Username",
                                  hintText: "user123",
                                  prefixIcon: Icon(Icons.person),
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
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(30)
                              ],
                              controller: _emailController,
                              onChanged: (email) => onEmailChanged(email),
                              decoration: InputDecoration(
                                  focusColor: Colors.white,
                                  labelText: "Email",
                                  hintText: "email@mail.com",
                                  prefixIcon: Icon(Icons.email),
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
                                absorbing: overall ? false : true,
                                child: AnimatedContainer(
                                    curve: Curves.fastOutSlowIn,
                                    duration:
                                        const Duration(milliseconds: 1000),
                                    height: 40,
                                    width: overall ? 500 : 90,
                                    decoration: BoxDecoration(
                                        color: overall
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
