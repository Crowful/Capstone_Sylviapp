import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

enum Gender { male, female }

class _BasicInfoPageState extends State<BasicInfoPage> {
  bool overall = false;

  @override
  Widget build(BuildContext context) {
    Gender? _gender = Gender.male;

    return Container(
      padding: EdgeInsets.all(18),
      height: widget.height,
      width: widget.width,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                height: 150,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/register1.png'),
                        fit: BoxFit.contain))),
            Text(
              'Set up your account',
              style: GoogleFonts.openSans(
                  fontSize: 20, fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Fill-in the basic information that is needed for using our beloved application Sylviapp!',
              style: GoogleFonts.openSans(
                  fontSize: 13,
                  color: Colors.black.withOpacity(0.5),
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    icon: Icon(Icons.person),
                    onPressed: null,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.black)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.black)),
                  hintText: "Full Name",
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Card(
              elevation: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Gender"),
                  RadioListTile<Gender>(
                      title: Text("Male"),
                      value: Gender.male,
                      groupValue: _gender,
                      onChanged: (Gender? value) {
                        setState(() {
                          _gender = value;
                        });
                      }),
                  RadioListTile<Gender>(
                      title: Text("Female"),
                      value: Gender.female,
                      groupValue: _gender,
                      onChanged: (Gender? value) {
                        setState(() {
                          _gender = value;
                        });
                      }),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              decoration: InputDecoration(
                prefixIcon: IconButton(
                  icon: Icon(Icons.location_city),
                  onPressed: null,
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black)),
                hintText: "Address",
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              decoration: InputDecoration(
                prefixIcon: IconButton(
                  icon: Icon(Icons.phone),
                  onPressed: null,
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black)),
                hintText: "Contact Number",
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                    child: Container(
                        height: 30,
                        color: Colors.red[300],
                        child: widget.previousButton)),
                Expanded(
                  child: AbsorbPointer(
                    absorbing: overall ? false : true,
                    child: AnimatedContainer(
                      padding: EdgeInsets.all(5),
                      duration: Duration(milliseconds: 500),
                      height: 30,
                      curve: Curves.ease,
                      child: widget.nextButton,
                      decoration: BoxDecoration(
                          // color: _isUserFourCharacters && _isValidEmail
                          // ?
                          color: Colors.green
                          // : Colors.grey,
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
