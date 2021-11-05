import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sylviapp_project/animation/FadeAnimation.dart';
import 'package:sylviapp_project/providers/providers.dart';
import 'package:sylviapp_project/screens/campaign_module/campaign_monitor_volunteer.dart';
import 'analytics_module/bar_graph.dart';
import 'campaign_module/join_donate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  bool noCampaign = false;
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
              color: Theme.of(context).backgroundColor,
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
                  children: [firstHome(), secondHome(), thirdHome()]),
              FadeAnimation(
                1.6,
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SizeTransition(
                      sizeFactor: _hide,
                      child: Card(
                        color: Colors.transparent,
                        elevation: 3,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                          height: 70,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Theme.of(context).dialogBackgroundColor,
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
                                child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      AnimatedContainer(
                                        duration: Duration(milliseconds: 300),
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
                                              Flexible(
                                                child: Wrap(
                                                  alignment:
                                                      WrapAlignment.center,
                                                  crossAxisAlignment:
                                                      WrapCrossAlignment.center,
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
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 15),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ]
                                          ],
                                        ),
                                      ),
                                      AnimatedOpacity(
                                        duration: Duration(milliseconds: 150),
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
                                child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      AnimatedContainer(
                                        duration: Duration(milliseconds: 300),
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
                                              Flexible(
                                                child: Wrap(
                                                  alignment:
                                                      WrapAlignment.center,
                                                  crossAxisAlignment:
                                                      WrapCrossAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .attach_money_rounded,
                                                      color: Colors.white,
                                                      size: 30,
                                                    ),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    Text(
                                                      'Donate',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 15),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ]
                                          ],
                                        ),
                                      ),
                                      AnimatedOpacity(
                                        duration: Duration(milliseconds: 500),
                                        opacity: currentPage != 1 ? 1 : 0,
                                        child: Icon(
                                          Icons.monetization_on,
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
                                  homePageController.jumpToPage(2);
                                },
                                child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      AnimatedContainer(
                                        duration: Duration(milliseconds: 300),
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
                                              Flexible(
                                                child: Wrap(
                                                  alignment:
                                                      WrapAlignment.center,
                                                  crossAxisAlignment:
                                                      WrapCrossAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.analytics,
                                                      color: Colors.white,
                                                      size: 30,
                                                    ),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    Text(
                                                      'Analytics',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 15),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ]
                                          ],
                                        ),
                                      ),
                                      AnimatedOpacity(
                                        duration: Duration(milliseconds: 500),
                                        opacity: currentPage != 2 ? 1 : 0,
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
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }

  Widget secondHome() {
    return Container(
      child: Column(
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
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              'All Reforestation Campaign',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xff65BFB8)),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('campaigns')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                    child: NotificationListener(
                      onNotification: _handleScrollNotification,
                      child: RefreshIndicator(
                        onRefresh: () async {},
                        child: ListView(
                            children: snapshot.data!.docs.map((e) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => JoinDonateCampaign(
                                            uidOfCampaign: e.id,
                                            uidOfOrganizer: e.get("uid"),
                                          )));
                            },
                            child: FadeAnimation(
                                (1.0 + snapshot.data!.docs.length) / 4,
                                availableCampaign(name: e['campaign_name'])),
                          );
                        }).toList()),
                      ),
                    ),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              })
        ],
      ),
    );
  }

  Widget thirdHome() {
    return Container(
      child: Column(
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
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              'Analytics in Overall Reforestation',
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {},
              child: Container(
                  height: 250,
                  width: double.infinity,
                  child: FadeAnimation(1, BarChartSample3())),
            ),
          )
        ],
      ),
    );
    // return Column(
    //   children: [
    //     Container(height: 250, width: 360, child: BarChartSample3()),
    //   ],
    // );
  }

  Widget firstHome() {
    return Container(
      child: Column(
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
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FadeAnimation(
                  0.25,
                  Text(
                    'Overview',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/wrapperMap');
                  },
                  child: Center(
                      child: FadeAnimation(
                    0.5,
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          image: DecorationImage(
                              image: AssetImage("assets/images/map.jpg"),
                              fit: BoxFit.cover)),
                    ),
                  )),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Your Campaigns',
                  style: Theme.of(context).textTheme.headline1,
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(context.read(authserviceProvider).getCurrentUserUID())
                  .collection("campaigns")
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                } else {
                  return Expanded(
                    child: NotificationListener(
                      child: noCampaign == true
                          ? FadeAnimation(
                              1,
                              Center(
                                  child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.sentiment_dissatisfied,
                                      size: 30,
                                      color: Colors.grey.withOpacity(0.7)),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text('No Active Campaign',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.withOpacity(0.7),
                                          fontSize: 25)),
                                ],
                              )),
                            )
                          : RefreshIndicator(
                              onRefresh: () async {},
                              child: ListView(
                                  children: snapshot.data!.docs.map((e) {
                                return StreamBuilder<DocumentSnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection("campaigns")
                                        .doc(e.id)
                                        .collection("volunteers")
                                        .doc(context
                                            .read(authserviceProvider)
                                            .getCurrentUserUID())
                                        .parent
                                        .parent!
                                        .snapshots(),
                                    builder: (context, snapshoteds) {
                                      if (!snapshoteds.hasData) {
                                        return CircularProgressIndicator();
                                      } else {
                                        List<Widget> entries = [];

                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        CampaignMonitorVolunteer(
                                                            uidOfCampaign:
                                                                snapshoteds
                                                                    .data!
                                                                    .id)));
                                          },
                                          child: FadeAnimation(
                                              (1.0 +
                                                      snapshot
                                                          .data!.docs.length) /
                                                  4,
                                              availableCampaign(
                                                  name: (snapshoteds.data!
                                                      .get("campaign_name")))),
                                        );
                                      }
                                    });
                              }).toList()),
                            ),
                      onNotification: _handleScrollNotification,
                    ),
                  );
                }
              })
        ],
      ),
    );
  }

  Widget campaignDialog() {
    return Dialog(
      child: Container(
        height: 20,
        width: 20,
        child: Center(
          child: Text('sds'),
        ),
      ),
    );
  }

  Widget availableCampaign({String? name}) {
    return Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7.5),
            color: Theme.of(context).dialogBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.7),
                spreadRadius: 0,
                blurRadius: 2,
                offset: Offset(0, 5),
              ),
            ]),
        child: Column(
          children: [
            Stack(children: [
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(7.5),
                        topRight: Radius.circular(7.5)),
                    image: DecorationImage(
                        image: AssetImage("assets/images/placeholder.jpg"),
                        fit: BoxFit.cover)),
              ),
              Padding(
                  padding: EdgeInsets.all(5),
                  child: Icon(
                    Icons.bookmark_add_outlined,
                    size: 28,
                    color: Colors.white,
                  ))
            ]),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: Text(name!,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff65BFB8))),
                ),
                Container(
                  child: Text("Description example lorem ipsum multiple jutsu",
                      style: TextStyle(
                          fontSize: 14,
                          overflow: TextOverflow.clip,
                          fontWeight: FontWeight.normal,
                          color: Colors.black.withOpacity(0.75))),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                  child: Text('₱250 raised of ₱10,100'),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                  child: Container(
                    height: 15,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      child: LinearProgressIndicator(
                        semanticsLabel: "Donated",
                        semanticsValue: "Donating",
                        backgroundColor: Colors.grey.withOpacity(0.3),
                        color: Color(0xff65BFB8),
                        minHeight: 10,
                        value: 0.25,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.people_alt,
                            color: Color(0xff65BFB8),
                            size: 20,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text('0/50')
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.paid,
                            color: Color(0xff65BFB8),
                            size: 20,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text('₱250')
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ));
  }
}
