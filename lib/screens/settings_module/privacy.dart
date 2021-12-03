import 'package:flutter/material.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({Key? key}) : super(key: key);

  @override
  _PrivacyScreenState createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Color(0xff65BFB8),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  color: Color(0xff403d55),
                ),
                Text(
                  'Sylviapp',
                  style: TextStyle(
                      color: Color(0xff65BFB8),
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.bookmark_outline),
                  onPressed: () {},
                  color: Colors.transparent,
                ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              "Privacy Policy",
              style: TextStyle(
                  color: Color(0xff65BFB8),
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
            Text(
              "Privacy policy using Sylviapp, the following are the scope and information about how sylviapp used data of volunteers and organizers (users).",
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Sylviapp respects the privacy of our users. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you visit our mobile application the Sylviapp. Please read this Privacy Policy carefully. IF YOU DO NOT AGREE WITH THE TERMS OF THIS PRIVACY POLICY, PLEASE DO NOT ACCESS THE APPLICATION. \n \n We reserve the right to make changes to this Privacy Policy at any time and for any reason. We will alert you about any changes by updating the “Last updated” date of this Privacy Policy. You are encouraged to periodically review this Privacy Policy to stay informed of updates. You will be deemed to have been made aware of, will be subject to, and will be deemed to have accepted the changes in any revised Privacy Policy by your continued use of the Application after the date such revised Privacy Policy is posted. \n\nThis Privacy Policy does not apply to the third-party online/mobile store from which you install the Application or make payments, including any in-game virtual items, which may also collect and use data about you. We are not responsible for any of the data collected by any such third party.",
              textAlign: TextAlign.justify,
            )
          ],
        ),
      ),
    ));
  }
}
