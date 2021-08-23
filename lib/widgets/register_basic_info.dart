import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BasicInfoPage extends StatefulWidget {
  const BasicInfoPage({Key? key}) : super(key: key);

  @override
  _BasicInfoPageState createState() => _BasicInfoPageState();
}

class _BasicInfoPageState extends State<BasicInfoPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
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
        ],
      ),
    );
  }
}
