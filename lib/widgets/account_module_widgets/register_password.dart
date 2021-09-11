import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
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

class _PasswordRegPageState extends State<PasswordRegPage> {
  final TextEditingController _primaryPaswword = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final userName = "";
  bool _isVisible = false;
  bool _isPasswordEightCharacters = false;
  bool _hasPasswordOneNumber = false;
  bool _isMatch = false;
  bool _isVisibleCP = false;
  bool _overall = false;

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
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      height: widget.height,
      width: widget.width,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/register1.png"),
                        fit: BoxFit.contain))),
            SizedBox(
              height: 20,
            ),
            Text(
              'Set up your password',
              style: GoogleFonts.openSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff63FF7D)),
            ),
            SizedBox(
              height: 0,
            ),
            Text(
              'Enter your password for your account and make sure it contains atleast 1 number and has a length of 8 characters.',
              style: GoogleFonts.openSans(
                  fontSize: 13,
                  color: Colors.black.withOpacity(0.5),
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: TextField(
                controller: _primaryPaswword,
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
                      borderSide:
                          BorderSide(color: Color(0xff403d55), width: 2.5)),
                  hintText: "Password",
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: TextField(
                controller: _confirmPassword,
                onChanged: (password) => onConfirmPasswordChange(password),
                obscureText: !_isVisibleCP,
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
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.black)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          BorderSide(color: Color(0xff403d55), width: 2.5)),
                  hintText: "Confirm Password",
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                ),
              ),
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
            Row(children: [
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
            ]),
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
                      color: _isMatch ? Colors.green : Colors.transparent,
                      border: _isMatch
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
                Text("Password Matched"),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    child: Container(
                        padding: EdgeInsets.all(5),
                        height: 30,
                        color: Colors.red[300],
                        child: widget.previousButton)),
                Expanded(
                  child: AbsorbPointer(
                    absorbing: _overall ? false : true,
                    child: AnimatedContainer(
                      padding: EdgeInsets.all(5),
                      duration: Duration(milliseconds: 500),
                      height: 30,
                      curve: Curves.ease,
                      child: widget.nextButton,
                      decoration: BoxDecoration(
                        color: _hasPasswordOneNumber &&
                                _isPasswordEightCharacters &&
                                _isMatch
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
