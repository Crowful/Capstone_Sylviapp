import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  final AnimationController controller;
  final Duration duration;
  const HomePage({Key? key, required this.controller, required this.duration})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool menuOpen = false;
  late Animation<double> _scaleAnimation =
      Tween<double>(begin: 1, end: 0.6).animate(widget.controller);

  @override
  Widget build(BuildContext context) {
    if (_scaleAnimation == null) {
      _scaleAnimation =
          Tween<double>(begin: 1, end: 0.6).animate(widget.controller);
    }
    var size = MediaQuery.of(context).size;
    return AnimatedPositioned(
      duration: widget.duration,
      top: 0,
      bottom: -50,
      left: menuOpen ? 0.3 * size.width : 0,
      right: menuOpen ? -0.4 * size.width : 0,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: menuOpen
                  ? BorderRadius.circular(30)
                  : BorderRadius.circular(0)),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(height: 35),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    !menuOpen
                        ? IconButton(
                            icon: Icon(Icons.menu),
                            onPressed: () {
                              setState(() {
                                widget.controller.forward();
                                menuOpen = true;
                              });
                            },
                            color: Color(0xff403d55),
                          )
                        : IconButton(
                            icon: Icon(Icons.arrow_back_ios),
                            onPressed: () {
                              setState(() {
                                widget.controller.reverse();
                                menuOpen = false;
                              });
                            },
                            color: Color(0xff403d55),
                          ),
                    IconButton(
                      icon: Icon(Icons.notifications),
                      onPressed: null,
                      color: Colors.blueAccent,
                    )
                  ],
                ),
                SizedBox(height: 15),
                Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: Colors.black26),
                ),
                SizedBox(
                  height: 20,
                ),
                Text('Campaigns',
                    style: GoogleFonts.roboto(fontWeight: FontWeight.bold))
              ],
            ),
          ),
        ),
      ),
    );
    // return SingleChildScrollView(
    //   child: Container(
    //     height: height,
    //     width: width,
    //     child: Column(
    //       children: [
    //         ElevatedButton(
    //             onPressed: () {
    //               Navigator.pushNamed(context, "/register");
    //             },
    //             child: Text('Register')),
    //         ElevatedButton(
    //             onPressed: () {
    //               Navigator.pushNamed(context, "/settings");
    //             },
    //             child: Text('Settings')),
    //         ElevatedButton(
    //             onPressed: () {
    //               Navigator.pushNamed(context, "/basicReg");
    //             },
    //             child: Text('bsic')),
    //         ElevatedButton(
    //             onPressed: () {
    //               Navigator.pushNamed(context, "/forgot_password");
    //             },
    //             child: Text('Forgotpass')),
    //         ElevatedButton(
    //             onPressed: () {
    //               Navigator.pushNamed(context, "/login");
    //             },
    //             child: Text('login Screen')),
    //         ElevatedButton(
    //             onPressed: () {
    //               Navigator.pushNamed(context, "/onboarding");
    //             },
    //             child: Text('onboarding screen'))
    //       ],
    //     ),
    //   ),
    // );
  }
}
