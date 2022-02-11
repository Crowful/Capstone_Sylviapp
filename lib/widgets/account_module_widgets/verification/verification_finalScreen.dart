import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VerificationFinalScreen extends StatefulWidget {
  const VerificationFinalScreen({Key? key}) : super(key: key);

  @override
  _VerificationFinalScreenState createState() =>
      _VerificationFinalScreenState();
}

class _VerificationFinalScreenState extends State<VerificationFinalScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.transparent,
                      ),
                      onPressed: () {},
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
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.how_to_reg_outlined,
                        size: 100,
                        color: Color(0xff65BFB8),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Application Submitted!",
                            style: TextStyle(
                                color: Color(0xff65BFB8),
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Wait for 2 - 10 days for us to verify your account.",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/home');
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color(0xff65BFB8),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              height: 40,
                              width: 110,
                              child: Center(
                                child: Text("Go to home"),
                              ),
                            ),
                          )
                        ],
                      ),
                    ]),
                Icon(Icons.ac_unit, color: Colors.transparent)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
