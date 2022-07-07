import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sylviapp_project/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController _emailController = TextEditingController();
  // ignore: unused_field
  bool _hasPasswordOneNumber = false;
  // ignore: unused_field
  bool _isValidEmail = false;
  // ignore: unused_field
  bool _isVisible = false;

  onEmailChanged(String email) {
    final charRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9]+@[a-zA-Z0-9]+[.]+[com]+");
    setState(() {
      _isValidEmail = false;
      if (charRegex.hasMatch(email)) _isValidEmail = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Text("Forgot Password",
              style: TextStyle(
                  color: Color(0xff65BFB8),
                  fontSize: 25,
                  fontWeight: FontWeight.bold)),
          SizedBox(
            height: 20,
          ),
          Text(
            'Enter your email and we will email you a form for your new password',
            style:
                GoogleFonts.openSans(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            child: TextFormField(
              controller: _emailController,
              onChanged: (email) => onEmailChanged(email),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black)),
                hintText: "Email",
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Center(
            child: Container(
              height: 60,
              width: 300,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Color(0xff65BFB8), shape: StadiumBorder()),
                  onPressed: () {
                    if (_emailController.text == "") {
                      Fluttertoast.showToast(
                          msg: 'The Email must not be blank');
                    } else {
                      context
                          .read(authserviceProvider)
                          .resetPass(_emailController.text, context);

                      _emailController.clear();
                    }
                  },
                  child: Text("Send Request Password to my Email")),
            ),
          )
        ],
      ),
    );
  }
}
