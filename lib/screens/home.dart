import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sylviapp_project/animation/FadeAnimation.dart';
import 'package:sylviapp_project/providers/providers.dart';
import 'package:sylviapp_project/screens/campaign_module/campaign_monitor_organizer.dart';
import 'package:sylviapp_project/screens/campaign_module/campaign_monitor_volunteer.dart';

import 'analytics_module/bar_graph.dart';
import 'campaign_module/join_donate.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sylviapp_project/translations/locale_keys.g.dart';
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
  bool isJoin = false;
  bool isOrganizer = false;

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
    //
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
    // ignore: unnecessary_null_comparison
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
              onPressed: () {
                showCupertinoDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CupertinoAlertDialog(
                        title: Text("Are You sure you want to log out ?"),
                        content: Text(
                            "this will log out your account in this device"),
                        actions: [
                          CupertinoDialogAction(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("no")),
                          CupertinoDialogAction(
                              onPressed: () async {
                                await context
                                    .read(authserviceProvider)
                                    .signOut();

                                await Navigator.of(context)
                                    .pushNamedAndRemoveUntil('/wrapperAuth',
                                        (Route<dynamic> route) => false);
                              },
                              child: Text("yes")),
                        ],
                      );
                    });
              },
              color: Colors.transparent,
            ),
          ]),
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              LocaleKeys.allreforestationcampaign.tr(),
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
                                return StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('campaigns')
                                        .doc(e.id)
                                        .collection('volunteers')
                                        .snapshots(),
                                    builder: (context, snapshotedsd) {
                                      if (!snapshotedsd.hasData) {
                                        return CircularProgressIndicator();
                                      } else {
                                        return StreamBuilder<DocumentSnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection('campaigns')
                                                .doc(e.id)
                                                .snapshots(),
                                            builder: (context, snapshotyarn) {
                                              if (snapshotyarn.hasError &&
                                                  snapshot.connectionState ==
                                                      ConnectionState.waiting) {
                                                return Center(
                                                    child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    CircularProgressIndicator(),
                                                    Text(
                                                        'Please Check your Internet',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.7),
                                                            fontSize: 25))
                                                  ],
                                                ));
                                                // ignore: unrelated_type_equality_checks
                                              } else {
                                                return GestureDetector(
                                                  onTap: () async {
                                                    try {
                                                      if (snapshotyarn.data!
                                                              .get('uid') ==
                                                          context
                                                              .read(
                                                                  authserviceProvider)
                                                              .getCurrentUserUID()) {
                                                        setState(() {
                                                          isOrganizer = true;
                                                        });
                                                      } else {
                                                        setState(() {
                                                          isOrganizer = false;
                                                        });

                                                        if (snapshotedsd.data!
                                                            .docs.isEmpty) {
                                                          setState(() {
                                                            isJoin = false;
                                                          });
                                                        } else {
                                                          snapshotedsd
                                                              .data!.docs
                                                              .forEach(
                                                                  (element) {
                                                            if (context
                                                                    .read(
                                                                        authserviceProvider)
                                                                    .getCurrentUserUID() ==
                                                                element.get(
                                                                    "volunteerUID")) {
                                                              setState(() {
                                                                isJoin = true;
                                                              });
                                                            } else if (context
                                                                    .read(
                                                                        authserviceProvider)
                                                                    .getCurrentUserUID() !=
                                                                element.get(
                                                                    "volunteerUID")) {
                                                              setState(() {
                                                                isJoin = false;
                                                              });
                                                            } else {
                                                              setState(() {
                                                                isJoin = false;
                                                              });
                                                            }
                                                          });
                                                        }
                                                      }

                                                      if (isJoin == true &&
                                                          isOrganizer ==
                                                              false) {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    CampaignMonitorVolunteer(
                                                                        uidOfCampaign:
                                                                            e.id)));
                                                      } else if (isJoin ==
                                                              false &&
                                                          isOrganizer ==
                                                              false) {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        JoinDonateCampaign(
                                                                          uidOfCampaign:
                                                                              e.id,
                                                                          uidOfOrganizer:
                                                                              e.get("uid"),
                                                                          nameOfCampaign:
                                                                              e.get("campaign_name"),
                                                                          city:
                                                                              e.get("city"),
                                                                          currentFund:
                                                                              e.get("current_donations"),
                                                                          currentVolunteer:
                                                                              e.get("current_volunteers"),
                                                                          totalVolunteer:
                                                                              e.get("number_volunteers"),
                                                                          maxFund:
                                                                              e.get("max_donation"),
                                                                          address:
                                                                              e.get("address"),
                                                                          description:
                                                                              e.get("description"),
                                                                        )));
                                                      } else if (isOrganizer ==
                                                          true) {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        CampaignMonitorOrganizer(
                                                                          uidOfCampaign:
                                                                              e.id,
                                                                        )));
                                                      }
                                                    } catch (e) {
                                                      print(e);
                                                    }
                                                  },
                                                  child: FadeAnimation(
                                                      (1.0 +
                                                              snapshot
                                                                  .data!
                                                                  .docs
                                                                  .length) /
                                                          4,
                                                      availableCampaign(
                                                          uid: e['uid'],
                                                          name: e[
                                                              'campaign_name'],
                                                          description:
                                                              e['description'],
                                                          rfund: e[
                                                              'current_donations'],
                                                          tfund:
                                                              e['max_donation'],
                                                          volunteerCurrent: e[
                                                              'current_volunteers'],
                                                          volunteerMax: e[
                                                              'number_volunteers'])),
                                                );
                                              }
                                            });
                                      }
                                    });
                              }).toList()))));
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
              color: Colors.transparent,
            ),
          ]),
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              LocaleKeys.analyticsinoverallreforestation.tr(),
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("campaigns")
                  .where('isActive', isEqualTo: true)
                  .snapshots(),
              builder: (context, snapshotAnalyticsActive) {
                if (!snapshotAnalyticsActive.hasData) {
                  return CircularProgressIndicator();
                } else {
                  return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("campaigns")
                          .where('inProgress', isEqualTo: true)
                          .snapshots(),
                      builder: (context, snapshotAnalyticsProgress) {
                        if (!snapshotAnalyticsProgress.hasData) {
                          return CircularProgressIndicator();
                        } else {
                          return Expanded(
                            child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection("campaigns")
                                    .where('isCompleted', isEqualTo: true)
                                    .snapshots(),
                                builder: (context, snapshotAnalyticsDone) {
                                  if (!snapshotAnalyticsDone.hasData) {
                                    return CircularProgressIndicator();
                                  } else {
                                    int campaignDone =
                                        snapshotAnalyticsDone.data!.size;
                                    int campaignInProgress =
                                        snapshotAnalyticsProgress.data!.size;
                                    int campaignActive =
                                        snapshotAnalyticsActive.data!.size;
                                    return RefreshIndicator(
                                      onRefresh: () async {},
                                      child: Container(
                                          width: double.infinity,
                                          child: FadeAnimation(
                                              1,
                                              Chart(
                                                campaignInProgress:
                                                    campaignInProgress,
                                                doneCampaign: campaignDone,
                                                activeCampaign: campaignActive,
                                              ))),
                                    );
                                  }
                                }),
                          );
                        }
                      });
                }
              })
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
              color: Colors.transparent,
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
                    LocaleKeys.overview.tr(),
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
                  LocaleKeys.yourcampaigns.tr(),
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
                } else if (snapshot.data!.docs.isEmpty) {
                  return FadeAnimation(
                    1,
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 100, 0, 0),
                      child: Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.sentiment_dissatisfied,
                              size: 30, color: Colors.grey.withOpacity(0.7)),
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
                    ),
                  );
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
                                      if (!snapshoteds.hasData &&
                                          snapshoteds.connectionState ==
                                              ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      } else {
                                        if (snapshoteds.data!.exists) {
                                          return GestureDetector(
                                              onTap: () {
                                                if (context
                                                        .read(
                                                            authserviceProvider)
                                                        .getCurrentUserUID() ==
                                                    snapshoteds.data!
                                                        .get('uid')) {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              CampaignMonitorOrganizer(
                                                                  uidOfCampaign:
                                                                      snapshoteds
                                                                          .data!
                                                                          .id)));
                                                } else {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              CampaignMonitorVolunteer(
                                                                  uidOfCampaign:
                                                                      snapshoteds
                                                                          .data!
                                                                          .id)));
                                                }
                                              },
                                              child: FadeAnimation(
                                                  (1.0 +
                                                          snapshot.data!.docs
                                                              .length) /
                                                      4,
                                                  availableCampaign(
                                                    uid: snapshoteds.data!
                                                        .get("uid"),
                                                    name: snapshoteds.data!
                                                        .get("campaign_name"),
                                                    description: snapshoteds
                                                        .data!
                                                        .get("description"),
                                                    rfund: snapshoteds.data!.get(
                                                        "current_donations"),
                                                    tfund: snapshoteds.data!
                                                        .get("max_donation"),
                                                    volunteerCurrent:
                                                        snapshoteds.data!.get(
                                                            "current_volunteers"),
                                                    volunteerMax:
                                                        snapshoteds.data!.get(
                                                            "number_volunteers"),
                                                  )));
                                        } else {
                                          return Center(
                                            child: Container(
                                              height: 100,
                                              width: 400,
                                              child: Card(
                                                child: Column(children: [
                                                  Text(
                                                      'This Campaign has been deleted by the Admin'),
                                                  ElevatedButton(
                                                      onPressed: () {
                                                        context
                                                            .read(
                                                                authserviceProvider)
                                                            .deleteRecentCampaign(
                                                                snapshoteds
                                                                    .data!.id);
                                                      },
                                                      child: Text('remove')),
                                                ]),
                                              ),
                                            ),
                                          );
                                        }
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

  Widget availableCampaign({
    String? name,
    required String description,
    required String uid,
    required int rfund,
    required int tfund,
    required int volunteerCurrent,
    required int volunteerMax,
  }) {
    double meterValue = rfund / tfund;

    int raisedFund = rfund;
    int totalFund = tfund;
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
              uid ==
                      context
                          .read(authserviceProvider)
                          .getCurrentUserUID
                          .toString()
                  ? Padding(
                      padding: EdgeInsets.all(5),
                      child: Text('You are the Organizer here',
                          style: TextStyle(color: Colors.white)))
                  : Padding(padding: EdgeInsets.all(5), child: Text('test'))
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
                  child: Text(description,
                      style: TextStyle(
                        fontSize: 14,
                        overflow: TextOverflow.clip,
                        fontWeight: FontWeight.normal,
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                  child: Text(
                    '₱' +
                        raisedFund.toString() +
                        ' raised of ' +
                        '₱' +
                        totalFund.toString(),
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
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
                        value: meterValue,
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
                          Text(volunteerCurrent.toString() +
                              '/' +
                              volunteerMax.toString())
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
                          Text('₱' + raisedFund.toString())
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
