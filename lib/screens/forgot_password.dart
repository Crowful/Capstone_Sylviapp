import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordScreen extends StatefulWidget {


  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool _isVisible = false;
  bool _isValidEmail = false;
  bool _hasPasswordOneNumber = false;

  

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
      appBar: AppBar(title:  Text(
              'Forgot Password',
              style:
                  GoogleFonts.openSans(fontSize: 15, fontWeight: FontWeight.w700),
            ),),
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
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: TextField(
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
                AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                      color: _isValidEmail
                          ? Colors.green
                          : Colors.transparent,
                      border: _isValidEmail
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
                Text("Valid Email")
              ],
            ),
            SizedBox(
              height: 10,
            ),
                Row(
                  children: [
                    AbsorbPointer(
                      absorbing:
                          _isValidEmail
                              ? false
                              : true,
                      child: GestureDetector(
                        onTap: (){
                          print("request new pass");
                        },
                        child: AnimatedContainer(
                          padding: EdgeInsets.all(5),
                          duration: Duration(milliseconds: 500),
                          height: 30,
                          curve: Curves.ease,
                          child: Text("Request for new Password"),
                          decoration: BoxDecoration(
                            color:
                                _isValidEmail
                                    ? Colors.green
                                    : Colors.grey,
                          ),
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
