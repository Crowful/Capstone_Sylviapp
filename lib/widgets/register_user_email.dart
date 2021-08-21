import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';

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
  UserRegPageState createState() => UserRegPageState();
}

class UserRegPageState extends State<UserRegPage> {
  bool _isVisible = false;
  bool _isUserFourCharacters = false;
  bool _isValidEmail = false;
  Color active = Colors.grey;
  bool overall = false;

  onUserChanged(String user) {
    setState(() {
      _isUserFourCharacters = false;
      if (user.length >= 4) {
        _isUserFourCharacters = true;
      }
    });
  }

  onEmailChanged(String email) {
    final charRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9]+@[a-zA-Z0-9]+[.]+[com]+");
    setState(() {
      _isValidEmail = false;
      if (charRegex.hasMatch(email)) _isValidEmail = true;
    });
    charRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18),
      height: widget.height,
      width: widget.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //   ElevatedButton(onPressed: ()=> context.of(themingProvider) , child: Text()),
          Text(
            'Set up your account',
            style:
                GoogleFonts.openSans(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            'Enter your username and email to identify yourself',
            style: GoogleFonts.openSans(
                fontSize: 13,
                color: Colors.black.withOpacity(0.5),
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            child: TextField(
              onChanged: (user) => onUserChanged(user),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: Colors.black12)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: Colors.black87)),
                hintText: "Enter your Username",
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: TextField(
              onChanged: (email) => onEmailChanged(email),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: Colors.black12)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: Colors.black87)),
                hintText: "Enter your Email",
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 500),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                    color: _isUserFourCharacters
                        ? Colors.green
                        : Colors.transparent,
                    border: _isUserFourCharacters
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
              Text("Contains at least 4 characters")
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
                    color: _isValidEmail ? Colors.green : Colors.transparent,
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
            height: 20,
          ),
          Row(
            children: [
              AbsorbPointer(
                absorbing:
                    _isUserFourCharacters && _isValidEmail ? false : true,
                child: AnimatedContainer(
                  padding: EdgeInsets.all(5),
                  duration: Duration(milliseconds: 500),
                  height: 30,
                  curve: Curves.ease,
                  child: widget.nextButton,
                  decoration: BoxDecoration(
                    color: _isUserFourCharacters && _isValidEmail
                        ? Colors.green
                        : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
