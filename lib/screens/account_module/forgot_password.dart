import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sylviapp_project/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool _isVisible = false;
  bool _isValidEmail = false;
  bool _hasPasswordOneNumber = false;

  TextEditingController _emailController = TextEditingController();

  onEmailChanged(String email) {
    final charRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9]+@[a-zA-Z0-9]+[.]+[com]+");
    setState(() {
      _isValidEmail = false;
      if (charRegex.hasMatch(email)) _isValidEmail = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Forgot Password',
          style:
              GoogleFonts.openSans(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 0,
            ),
            Text(
              'Enter your email and we will email you a form for your new password',
              style: GoogleFonts.openSans(
                  fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: TextField(
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
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    context
                        .read(authserviceProvider)
                        .resetPass(_emailController.text)
                        .whenComplete(() => (print(
                            "successfully sent an reset password email")));

                    _emailController.clear();
                  },
                  child: AnimatedContainer(
                    padding: EdgeInsets.all(5),
                    duration: Duration(milliseconds: 500),
                    height: 30,
                    curve: Curves.ease,
                    child: Text("Request for new Password"),
                    decoration: BoxDecoration(
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
