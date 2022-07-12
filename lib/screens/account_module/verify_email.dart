import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sylviapp_project/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({Key? key}) : super(key: key);

  @override
  _VerifyEmailState createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail>
    with TickerProviderStateMixin {
  bool limitRequest = false;
  late final AnimationController _controller;

  _lockButton() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var _date = DateTime.now();
    await prefs.setString('lastPressed', _date.toString());
  }

  _initialButtonState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastPressed', 'nothing');
  }

  _letRestrictionGone() async {
    Timer timerButton = Timer(Duration(minutes: 3), () {
      setState(() {
        limitRequest = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _initialButtonState();

    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(20),
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
              ),
              Lottie.asset('assets/images/sendEmailAnimation.json',
                  height: 200,
                  width: 200,
                  controller: _controller, onLoaded: (composition) {
                _controller.duration = Duration(milliseconds: 3000);
                _controller.animateTo(0.6);
              }),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Email Verification Sent!",
                    style: TextStyle(
                        color: Color(0xff65BFB8),
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Please check your email for verification to access Sylviapp.",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/login");
                  context.read(authserviceProvider).signOut();
                },
                child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                        color: Color(0xff65BFB8),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Center(child: Text("Go Login"))),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  var _getData = prefs.getString('lastPressed');
                  if (_getData != 'nothing') {
                    var _date = DateTime.parse(prefs.getString('lastPressed')!)
                        .add(Duration(minutes: 3));

                    if (_date.isBefore(DateTime.now())) {
                      setState(() {
                        limitRequest = false;
                      });
                      context
                          .read(authserviceProvider)
                          .requestForNewVerificationEmail()
                          .whenComplete(() {
                        _controller.reset();
                        _controller.animateTo(0.6);
                      });
                      _lockButton();
                      setState(() {
                        limitRequest = true;
                      });
                      Fluttertoast.showToast(msg: "success");
                    } else {
                      limitRequest = true;
                      Fluttertoast.showToast(
                          msg: "You can request again after 3 minutes");
                    }
                  } else {
                    if (limitRequest == false) {
                      context
                          .read(authserviceProvider)
                          .requestForNewVerificationEmail()
                          .whenComplete(() {
                        _controller.reset();
                        _controller.animateTo(0.6);
                      });
                      _lockButton();
                      _letRestrictionGone();
                      setState(() {
                        limitRequest = true;
                      });
                      Fluttertoast.showToast(msg: "success");
                    } else {
                      Fluttertoast.showToast(
                          msg: "You can request again after 3 minutes");
                    }
                  }
                },
                child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                        color:
                            limitRequest ? Colors.black12 : Color(0xff65BFB8),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Center(
                        child: Text("Request for new email verification"))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
