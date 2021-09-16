import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sylviapp_project/providers/providers.dart';
import 'package:sylviapp_project/widgets/campaign_module/campaign_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends StatefulWidget {
  final AnimationController controller;
  final Duration duration;
  const HomePage({Key? key, required this.controller, required this.duration})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
//Animation
  bool hold = false;
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
      bottom: menuOpen ? -50 : 0,
      left: menuOpen ? 0.3 * size.width : 0,
      right: menuOpen ? -0.4 * size.width : 0,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
              borderRadius: menuOpen
                  ? BorderRadius.all(Radius.circular(20))
                  : BorderRadius.all(Radius.circular(0))),
          child: Scaffold(
            body: Stack(children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        !menuOpen
                            ? IconButton(
                                icon: Icon(
                                  Icons.menu,
                                  color: Color(0xff65BFB8),
                                ),
                                onPressed: () {
                                  setState(() {
                                    print(menuOpen);
                                    widget.controller.forward();
                                    menuOpen = true;
                                  });
                                },
                              )
                            : IconButton(
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  color: Color(0xff65BFB8),
                                ),
                                onPressed: () {
                                  setState(() {
                                    widget.controller.reverse();
                                    menuOpen = false;
                                  });
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
                          color: Color(0xff65BFB8),
                        ),
                      ]),
                  SizedBox(height: 15),
                  Container(
                    padding: EdgeInsets.all(10),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Overview',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff2b2b2b)),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        GestureDetector(
                          onLongPress: () {
                            Navigator.pushNamed(context, '/map');
                          },
                          onTapDown: (_) {
                            setState(() {
                              hold = true;
                            });
                          },
                          onTapUp: (_) {
                            setState(() {
                              hold = false;
                            });
                          },
                          child: Center(
                              child: Container(
                                  height: 150,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      image: DecorationImage(
                                          image: AssetImage(
                                              "assets/images/map.jpg"),
                                          fit: BoxFit.cover)),
                                  child: ClipRRect(
                                      child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        // ignore: dead_code
                                        sigmaX: hold ? 0.0 : 2.5,
                                        sigmaY: hold ? 0.0 : 2.5),
                                    child: Container(
                                      color: Colors.black.withOpacity(0.2),
                                    ),
                                  )))),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Ongoing Campaigns',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff2b2b2b)),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: 5,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                              margin: EdgeInsets.only(bottom: 5),
                              width: 20,
                              height: 140,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [Color(0xff65BFB8), Colors.blue],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(24))),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(24),
                                    child: Image.network(
                                      "https://images.unsplash.com/photo-1598335624134-5bceb5de202d?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80",
                                    ),
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(0, 10, 0, 10),
                                        child: Text("Tree Planting Title",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white)),
                                      ),
                                      Container(
                                        width: 245,
                                        child: Text(
                                            "This is an example description example description description example, example desctriotion description",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.white)),
                                      ),
                                      Container(
                                          margin:
                                              EdgeInsets.fromLTRB(20, 5, 0, 10),
                                          child: Text("20 Volunteers Needed",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.white))),
                                    ],
                                  ),
                                ],
                              ));
                        }),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    height: 70,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: Offset(0, 2),
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 100,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Color(0xff65BFB8),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.home,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    'Home',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.campaign,
                          color: Color(0xff65BFB8),
                        ),
                        Icon(Icons.restore, color: Color(0xff65BFB8)),
                        Icon(Icons.analytics, color: Color(0xff65BFB8)),
                        // Text('Campaigns'),
                        // Text('Analytics'),
                        // Text('Activities')
                      ],
                    ),
                  ),
                ),
              )
            ]),
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
