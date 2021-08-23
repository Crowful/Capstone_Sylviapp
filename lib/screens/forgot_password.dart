import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordScreen extends StatefulWidget {


  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool _isVisible = false;
  bool _isPasswordEightCharacters = false;
  bool _hasPasswordOneNumber = false;

  onPasswordChanged(String password) {
    final numericRegex = RegExp(r'[0-9]');

    setState(() {
      _isPasswordEightCharacters = false;
      if (password.length >= 8) _isPasswordEightCharacters = true;

      _hasPasswordOneNumber = false;
      if (numericRegex.hasMatch(password)) _hasPasswordOneNumber = true;
    });
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(18),
       
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Forgot Password',
              style:
                  GoogleFonts.openSans(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 0,
            ),
            Text(
              'Enter your designated username for Sylviapp.',
              style: GoogleFonts.openSans(
                  fontSize: 13,
                  color: Colors.black.withOpacity(0.5),
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: TextField(
                onChanged: (password) => onPasswordChanged(password),
                obscureText: !_isVisible,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isVisible = !_isVisible;
                      });
                    },
                    icon: _isVisible
                        ? Icon(
                            Icons.visibility,
                            color: Colors.black,
                          )
                        : Icon(
                            Icons.visibility_off,
                            color: Colors.grey,
                          ),
                  ),
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
                AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                      color: _isPasswordEightCharacters
                          ? Colors.green
                          : Colors.transparent,
                      border: _isPasswordEightCharacters
                          ? Border.all(color: Colors.transparent)
                          : Border.all(color: Colors.grey.withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(50)),
                  child: Center(
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
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
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                      color: _hasPasswordOneNumber
                          ? Colors.green
                          : Colors.transparent,
                      border: _hasPasswordOneNumber
                          ? Border.all(color: Colors.transparent)
                          : Border.all(color: Colors.grey.withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(50)),
                  child: Center(
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text("Contains at least 1 number"),
                SizedBox(
                  height: 20,
                ),
              ]),
                Row(
                  children: [
                    AbsorbPointer(
                      absorbing:
                          _hasPasswordOneNumber && _isPasswordEightCharacters
                              ? false
                              : true,
                      child: AnimatedContainer(
                        padding: EdgeInsets.all(5),
                        duration: Duration(milliseconds: 500),
                        height: 30,
                        curve: Curves.ease,
                        child: ElevatedButton(onPressed: (){
                          print("button pressed");
                        }, child: Text("Request for new password"),),
                        decoration: BoxDecoration(
                          color:
                              _hasPasswordOneNumber && _isPasswordEightCharacters
                                  ? Colors.green
                                  : Colors.grey,
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
