//TODO Finalize the validation of basic info

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sylviapp_project/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Gender { male, female }

class BasicInfoPage extends StatefulWidget {
  final double height;
  final double width;
  final Widget nextButton;
  final Widget previousButton;
  const BasicInfoPage(
      {Key? key,
      required this.nextButton,
      required this.height,
      required this.width,
      required this.previousButton})
      : super(key: key);

  @override
  _BasicInfoPageState createState() => _BasicInfoPageState();
}

class _BasicInfoPageState extends State<BasicInfoPage>
    with TickerProviderStateMixin {
  //Text Controller & Validations
  final _fullNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _contactController = TextEditingController();
  bool _fullNameValidate = false;
  bool _genderValidate = false;
  bool _addressValidate = false;
  bool _contactNumberValidate = false;
  bool _overall = false;

  onValidate() {
    setState(() {
      _overall = false;
      if (_fullNameValidate == true &&
          _addressValidate == true &&
          _contactNumberValidate == true) {
        _overall = true;
      }

      context.read(userAccountProvider).setFullname(_fullNameController.text);

      context.read(userAccountProvider).setGender(_gender);

      context.read(userAccountProvider).setAddress(_addressController.text);

      context.read(userAccountProvider).setContact(_contactController.text);
    });
  }

  onFullNameChanged(String name) {
    setState(() {
      _fullNameValidate = false;
      if (name.length >= 4) {
        _fullNameValidate = true;
        onValidate();
      }
    });
  }

  onAddressChanged(String address) {
    setState(() {
      _addressValidate = false;
      if (address.length >= 4) {
        _addressValidate = true;
        onValidate();
      }
    });
  }

  onContactChanged(int? number) {
    setState(() {
      _contactNumberValidate = false;
      if (number! == 11) {
        _contactNumberValidate = true;
        onValidate();
      }
    });
  }

  String _gender = "male";

// Animation
  late AnimationController _animationController =
      AnimationController(vsync: this, duration: const Duration(seconds: 2))
        ..repeat(reverse: true);

  late AnimationController _widgetController =
      AnimationController(vsync: this, duration: Duration(seconds: 1));

  late Animation<Offset> _widgetTransition =
      Tween<Offset>(begin: Offset(0, -0.5), end: Offset.zero)
          .animate(_widgetController);

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
                              image: AssetImage("assets/images/userinfo.png"),
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
                    height: 80,
                  ),
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(15),
                        child: Column(
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
                                        curve: Curves.easeIn)),
                                child: Text(
                                    'Enter your desired password, it must have enough complexity to protect your own information.',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff3b3b3b)
                                            .withOpacity(0.8))),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        padding: EdgeInsets.all(15),
                        width: size.width,
                        child: Column(
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
                                controller: _fullNameController,
                                onChanged: (name) => {onFullNameChanged(name)},
                                decoration: InputDecoration(
                                    focusColor: Colors.white,
                                    labelText: "Full Name",
                                    prefixIcon: Icon(Icons.password),
                                    contentPadding: EdgeInsets.all(15),
                                    border: InputBorder.none),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                color: Colors.white.withOpacity(0.7),
                                semanticContainer: true,
                                margin: EdgeInsets.all(0),
                                elevation: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Wrap(
                                    children: [
                                      Text("Gender",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: Color(0xff2b2b2b))),
                                      RadioListTile<String>(
                                          title: Text(
                                            "Male",
                                          ),
                                          value: "male",
                                          groupValue: _gender,
                                          onChanged: (value) {
                                            setState(() {
                                              _gender = value!;
                                            });
                                          }),
                                      RadioListTile<String>(
                                          title: Text("Female"),
                                          value: "female",
                                          groupValue: _gender,
                                          onChanged: (value) {
                                            setState(() {
                                              _gender = value!;
                                            });
                                          }),
                                    ],
                                  ),
                                ),
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
                                controller: _addressController,
                                onChanged: (address) =>
                                    onAddressChanged(address),
                                decoration: InputDecoration(
                                    focusColor: Colors.white,
                                    labelText: "Address",
                                    prefixIcon: Icon(Icons.house),
                                    contentPadding: EdgeInsets.all(15),
                                    border: InputBorder.none),
                              ),
                            ),
                            SizedBox(
                              height: 10,
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
                                controller: _contactController,
                                onChanged: (contact) =>
                                    onContactChanged(int.parse(contact)),
                                decoration: InputDecoration(
                                    focusColor: Colors.white,
                                    labelText: "Contact Number",
                                    prefixIcon: Icon(Icons.phone),
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
                                  absorbing: _overall ? true : false,
                                  child: AnimatedContainer(
                                      curve: Curves.bounceInOut,
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
