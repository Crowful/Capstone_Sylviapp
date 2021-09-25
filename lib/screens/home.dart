import 'dart:ui';
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sylviapp_project/animation/FadeAnimation.dart';

class HomePage extends StatefulWidget {
  final AnimationController controller;
  final Duration duration;
  const HomePage({Key? key, required this.controller, required this.duration})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
//Animation
  bool hold = false;
  bool menuOpen = false;
  int currentPage = 0;
  late AnimationController _hide =
      AnimationController(vsync: this, duration: Duration(milliseconds: 500));
  late Animation<double> _scaleAnimation =
      Tween<double>(begin: 1, end: 0.6).animate(widget.controller);

  final PageController homePageController = PageController(initialPage: 0);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _hide =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    _hide.forward();
    currentPage = 0;
    homePageController.addListener(() {
      setState(() {
        currentPage = homePageController.page!.toInt();
      });
    });
  }

  @override
  void dispose() {
    _hide.dispose();
    super.dispose();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.depth == 0) {
      if (notification is UserScrollNotification) {
        final UserScrollNotification userScroll = notification;
        switch (userScroll.direction) {
          case ScrollDirection.forward:
            _hide.forward();
            break;
          case ScrollDirection.reverse:
            _hide.reverse();
            break;
          case ScrollDirection.idle:
            break;
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    _hide.forward();
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
              PageView(
                  scrollDirection: Axis.horizontal,
                  controller: homePageController,
                  children: [
                    firstHome(),
                    secondHome(),
                    thirdHome(),
                    fourthHome()
                  ]),
              FadeAnimation(
                1.6,
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SizeTransition(
                      sizeFactor: _hide,
                      axisAlignment: -1.0,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        height: 70,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(1),
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset: Offset(0, 1),
                              ),
                            ],
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  currentPage = 0;
                                });
                                homePageController.jumpToPage(0);
                              },
                              child:
                                  Stack(alignment: Alignment.center, children: [
                                AnimatedContainer(
                                  duration: Duration(milliseconds: 100),
                                  width: currentPage != 0 ? 0 : 100,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: Color(0xff65BFB8),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      if (currentPage == 0) ...[
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
                                      ]
                                    ],
                                  ),
                                ),
                                AnimatedOpacity(
                                  duration: Duration(milliseconds: 500),
                                  opacity: currentPage != 0 ? 1 : 0,
                                  child: Icon(
                                    Icons.home,
                                    color: Color(0xff65BFB8),
                                  ),
                                ),
                              ]),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  currentPage = 1;
                                });
                                homePageController.jumpToPage(1);
                              },
                              child:
                                  Stack(alignment: Alignment.center, children: [
                                AnimatedContainer(
                                  duration: Duration(milliseconds: 500),
                                  width: currentPage == 1 ? 120 : 0,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: Color(0xff65BFB8),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      if (currentPage == 1) ...[
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.announcement,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              'Campaign',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15),
                                            )
                                          ],
                                        ),
                                      ]
                                    ],
                                  ),
                                ),
                                AnimatedOpacity(
                                  duration: Duration(milliseconds: 500),
                                  opacity: currentPage != 1 ? 1 : 0,
                                  child: Icon(
                                    Icons.announcement,
                                    color: Color(0xff65BFB8),
                                  ),
                                ),
                              ]),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  currentPage = 2;
                                });
                              },
                              child:
                                  Stack(alignment: Alignment.center, children: [
                                AnimatedContainer(
                                  duration: Duration(milliseconds: 500),
                                  width: currentPage == 2 ? 120 : 0,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: Color(0xff65BFB8),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      if (currentPage == 2) ...[
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.announcement,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              'Campaign',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15),
                                            )
                                          ],
                                        ),
                                      ]
                                    ],
                                  ),
                                ),
                                AnimatedOpacity(
                                  duration: Duration(milliseconds: 500),
                                  opacity: currentPage != 2 ? 1 : 0,
                                  child: Icon(
                                    Icons.local_activity,
                                    color: Color(0xff65BFB8),
                                  ),
                                ),
                              ]),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  currentPage = 3;
                                });
                              },
                              child:
                                  Stack(alignment: Alignment.center, children: [
                                AnimatedContainer(
                                  duration: Duration(milliseconds: 500),
                                  width: currentPage == 3 ? 120 : 0,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: Color(0xff65BFB8),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      if (currentPage == 3) ...[
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.announcement,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              'Campaign',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15),
                                            )
                                          ],
                                        ),
                                      ]
                                    ],
                                  ),
                                ),
                                AnimatedOpacity(
                                  duration: Duration(milliseconds: 500),
                                  opacity: currentPage != 3 ? 1 : 0,
                                  child: Icon(
                                    Icons.analytics,
                                    color: Color(0xff65BFB8),
                                  ),
                                ),
                              ]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }

  Widget secondHome() {
    return Center(
      child: Text('Second'),
    );
  }

  Widget thirdHome() {
    return Center(
      child: Text('Second'),
    );
  }

  Widget fourthHome() {
    return Center(
      child: Text('Second'),
    );
  }

  Widget firstHome() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 15),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
              FadeAnimation(
                1,
                Text(
                  'Overview',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff2b2b2b)),
                ),
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
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            image: DecorationImage(
                                image: AssetImage("assets/images/map.jpg"),
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
          child: NotificationListener(
            child: ListView.builder(
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) {
                  return FadeAnimation(
                    (1.0 + index) / 4,
                    availableCampaign(),
                  );
                }),
            onNotification: _handleScrollNotification,
          ),
        )
      ],
    );
  }

  Widget availableCampaign() {
    return Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 0,
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ]),
        child: Row(
          children: [
            SizedBox(
              width: 30,
            ),
            Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Text("Tree Planting Title",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
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
                    margin: EdgeInsets.fromLTRB(20, 5, 0, 10),
                    child: Text("20 Volunteers Needed",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: Colors.white))),
              ],
            ),
          ],
        ));
  }
}
