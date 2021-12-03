import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sylviapp_project/Domain/aes_cryptography.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:sylviapp_project/animation/FadeAnimation.dart';
import 'package:sylviapp_project/animation/pop_up.dart';
import 'package:sylviapp_project/providers/providers.dart';
import 'package:sylviapp_project/screens/layout_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class CampaignMonitorVolunteer extends StatefulWidget {
  String uidOfCampaign;
  CampaignMonitorVolunteer({Key? key, required this.uidOfCampaign})
      : super(key: key);

  @override
  _CampaignMonitorVolunteerState createState() =>
      _CampaignMonitorVolunteerState();
}

class _CampaignMonitorVolunteerState extends State<CampaignMonitorVolunteer> {
  late LatLng userLatLng = LatLng(0, 0);
  late LatLng campaignLatLng = LatLng(0, 0);
  Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController mapController;

  void _onCameraMove(CameraPosition position) {
    userLatLng = position.target;
  }

  final markers = Set<Marker>();

  void check(CameraUpdate u, GoogleMapController c) async {
    c.animateCamera(u);
    mapController.animateCamera(u);
    LatLngBounds l1 = await c.getVisibleRegion();
    LatLngBounds l2 = await c.getVisibleRegion();
    print(l1.toString());
    print(l2.toString());
    if (l1.southwest.latitude == -90 || l2.southwest.latitude == -90)
      check(u, c);
  }

  void _onMapCreated(GoogleMapController controller) {
    if (!_controller.isCompleted) {
      mapController = controller;
      _controller.complete(controller);
      LatLngBounds bound =
          LatLngBounds(southwest: userLatLng, northeast: campaignLatLng);
      setState(() {
        controller.animateCamera(CameraUpdate.newLatLngBounds(bound, 50));
      });
    } else {}
  }

  @override
  void initState() {
    Geolocator.getCurrentPosition().then((currLocation) {
      setState(() {
        userLatLng = LatLng(14.7452, 121.0984);
        // new LatLng(currLocation.latitude, currLocation.longitude);
      });
    }).whenComplete(() {
      markers.add(
        Marker(
          icon: BitmapDescriptor.defaultMarker,
          markerId: MarkerId(userLatLng.toString()),
          position: userLatLng,
        ),
      );
      FirebaseFirestore.instance
          .collection('campaigns')
          .doc(widget.uidOfCampaign)
          .get()
          .then((value) {
        campaignLatLng = LatLng(value.get('latitude'), value.get('longitude'));
        markers.add(
          Marker(
            icon: BitmapDescriptor.defaultMarker,
            markerId: MarkerId(value.get('uid')),
            position: campaignLatLng,
          ),
        );
      });
    });

    FirebaseMessaging.onMessage.listen((event) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Notification"),
              content: Text(event.notification!.body!),
              actions: [
                TextButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: new LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return Scaffold(
          body: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("campaigns")
                  .doc(widget.uidOfCampaign)
                  .snapshots(),
              builder: (context, snapshotCampaignName) {
                if (!snapshotCampaignName.hasData) {
                  return CircularProgressIndicator();
                } else {
                  var campaignName =
                      snapshotCampaignName.data!.get("campaign_name");

                  var deviceTokenOrganizer =
                      snapshotCampaignName.data!.get("deviceTokenofOrganizer");

                  var date = snapshotCampaignName.data!.get("date_start");

                  var inProgress = snapshotCampaignName.data!.get("inProgress");

                  var orgID = snapshotCampaignName.data!.get("uid");
                  return PageView(
                    scrollDirection: Axis.vertical,
                    children: [
                      if (inProgress == true) ...[
                        secondPage(
                          orgID: orgID,
                          campaignName: campaignName,
                          initialCameraPosition:
                              CameraPosition(target: userLatLng, zoom: 14),
                          deviceToken: deviceTokenOrganizer,
                        ),
                      ],
                      firstPage(
                          campaignName: campaignName,
                          inProgress: inProgress,
                          date: date)
                    ],
                  );
                }
              }),
        );
      }),
    );
  }

  Widget secondPage(
      {required String campaignName,
      CameraPosition? initialCameraPosition,
      required String orgID,
      required String deviceToken}) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FadeAnimation(
                0.1,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back)),
                    Text(
                      "Sylviapp",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff65BFB8),
                          fontSize: 20),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.transparent,
                        )),
                  ],
                ),
              ),
              Expanded(
                child: FadeAnimation(
                  0.2,
                  Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            campaignName,
                            style: TextStyle(
                                fontSize: 35,
                                color: Color(0xff65BFB8),
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'The campaign is ongoing please do, plant trees.🌲',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Location Overview",
                            style: TextStyle(
                                fontSize: Theme.of(context)
                                        .textTheme
                                        .headline1!
                                        .fontSize! -
                                    1,
                                fontWeight: Theme.of(context)
                                    .textTheme
                                    .headline1!
                                    .fontWeight),
                          ),
                          Text(
                            "The markers below are both you and your organizer, so please do tap send distress when you need a help.",
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          FadeAnimation(
                            0.3,
                            Container(
                              height: 200,
                              width: double.infinity,
                              child: userLatLng == null
                                  ? Center(child: CircularProgressIndicator())
                                  : GoogleMap(
                                      onCameraMove: _onCameraMove,
                                      onMapCreated: _onMapCreated,
                                      markers: markers,
                                      buildingsEnabled: false,
                                      trafficEnabled: false,
                                      indoorViewEnabled: false,
                                      mapType: MapType.normal,
                                      initialCameraPosition:
                                          initialCameraPosition!,
                                      zoomControlsEnabled: false,
                                    ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          FadeAnimation(
                            0.6,
                            Text(
                              "Organizer Information",
                              style: TextStyle(
                                  fontSize: Theme.of(context)
                                          .textTheme
                                          .headline1!
                                          .fontSize! -
                                      5,
                                  fontWeight: Theme.of(context)
                                      .textTheme
                                      .headline1!
                                      .fontWeight),
                            ),
                          ),
                          FadeAnimation(
                              0.7,
                              StreamBuilder<DocumentSnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(orgID)
                                      .snapshots(),
                                  builder: (context, snapshotOrg) {
                                    if (!snapshotOrg.hasData) {
                                      return CircularProgressIndicator();
                                    } else {
                                      var orgName = AESCryptography()
                                          .decryptAES(enc.Encrypted.fromBase64(
                                              snapshotOrg.data!
                                                  .get('fullname')));
                                      var orgContact = AESCryptography()
                                          .decryptAES(enc.Encrypted.fromBase64(
                                              snapshotOrg.data!
                                                  .get('phoneNumber')));
                                      String? orgGender =
                                          toBeginningOfSentenceCase(
                                              AESCryptography().decryptAES(
                                                  enc.Encrypted.fromBase64(
                                                      snapshotOrg.data!
                                                          .get(("gender")))));
                                      return Container(
                                        padding: EdgeInsets.all(10),
                                        height: 100,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color:
                                                Colors.grey.withOpacity(0.25),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              orgName,
                                              style: TextStyle(
                                                fontSize: Theme.of(context)
                                                        .textTheme
                                                        .headline1!
                                                        .fontSize! -
                                                    2,
                                                fontWeight: Theme.of(context)
                                                    .textTheme
                                                    .headline1!
                                                    .fontWeight,
                                              ),
                                            ),
                                            Text(orgGender!),
                                            Text(orgContact)
                                          ],
                                        ),
                                      );
                                    }
                                  }))
                        ],
                      )),
                ),
              )
            ],
          ),
          FadeAnimation(
            0.9,
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () async {
                  print(deviceToken);
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(
                        context.read(authserviceProvider).getCurrentUserUID(),
                      )
                      .get()
                      .then((value) {
                    var fullname = AESCryptography().decryptAES(
                        enc.Encrypted.fromBase64(value.get('fullname')));
                    var gender = AESCryptography().decryptAES(
                        enc.Encrypted.fromBase64(value.get('gender')));
                    var phoneNumber = AESCryptography().decryptAES(
                        enc.Encrypted.fromBase64(value.get('phoneNumber')));
                    var address = AESCryptography().decryptAES(
                        enc.Encrypted.fromBase64(value.get('address')));
                    context.read(authserviceProvider).addMessage(
                        widget.uidOfCampaign,
                        orgID,
                        context.read(authserviceProvider).getCurrentUserUID(),
                        deviceToken,
                        fullname,
                        phoneNumber,
                        gender,
                        address);
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  decoration: BoxDecoration(
                      color: Color(0xff65BFB8),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  child: Center(
                    child: Text(
                      "Send Distress Call",
                      style: TextStyle(
                          fontWeight:
                              Theme.of(context).textTheme.headline1!.fontWeight,
                          color: Theme.of(context).textTheme.headline1!.color,
                          fontSize: 17),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget firstPage(
      {required String campaignName,
      required bool inProgress,
      required String date}) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.19,
              decoration: BoxDecoration(
                color: Color(0xff65BFB8),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 40,
                    right: 10,
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/userpass.png"))),
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(Icons.arrow_back)),
                            Text(
                              campaignName,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("campaigns")
                                .doc(widget.uidOfCampaign)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return CircularProgressIndicator();
                              } else {
                                return StreamBuilder<DocumentSnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(snapshot.data!.get('uid'))
                                        .snapshots(),
                                    builder: (context, snapshoteds) {
                                      if (!snapshoteds.hasData) {
                                        return CircularProgressIndicator();
                                      } else {
                                        return Container(
                                          padding: EdgeInsets.all(20),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              FadeAnimation(
                                                0.1,
                                                Text(
                                                  "Hello, " +
                                                      AESCryptography().decryptAES(enc
                                                              .Encrypted
                                                          .fromBase64(snapshoteds
                                                              .data!
                                                              .get(
                                                                  'fullname'))),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              FadeAnimation(
                                                0.3,
                                                Text(
                                                  "Below is information or announcement for the upcoming campaign.",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 13),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    });
                              }
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 0,
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("campaigns")
                            .doc(widget.uidOfCampaign)
                            .collection("volunteers")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return CircularProgressIndicator();
                          } else {
                            return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FadeAnimation(
                                    0.5,
                                    Text(
                                      "Announcement",
                                      style: TextStyle(
                                          color: Color(0xff65BFB8),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  FadeAnimation(
                                    0.7,
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height -
                                              670,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          color: Colors.grey.withOpacity(0.35)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          StreamBuilder<DocumentSnapshot>(
                                              stream: FirebaseFirestore.instance
                                                  .collection("campaigns")
                                                  .doc(widget.uidOfCampaign)
                                                  .collection("announcement")
                                                  .doc('announcement')
                                                  .snapshots(),
                                              builder: (context,
                                                  snapshotAnnouncement) {
                                                if (!snapshotAnnouncement
                                                    .hasData) {
                                                  return Text(
                                                      "No Announcement at the moment");
                                                } else if (snapshotAnnouncement
                                                        .hasData &&
                                                    snapshotAnnouncement
                                                        .data!.exists) {
                                                  return Text(snapshotAnnouncement
                                                      .data!
                                                      .get(
                                                          'currentAnnouncement'));
                                                } else {
                                                  return Text(
                                                      "No Announcement at the moment");
                                                }
                                              })
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  FadeAnimation(
                                    0.9,
                                    Text(
                                      "Volunteers: ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17),
                                    ),
                                  ),
                                  FadeAnimation(
                                    0.11,
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      height: 300,
                                      decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.25)),
                                      child: ListView(
                                          children:
                                              snapshot.data!.docs.map((e) {
                                        return GestureDetector(
                                          onTap: () {},
                                          child: Column(children: [
                                            StreamBuilder<DocumentSnapshot>(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection("users")
                                                    .doc(e["volunteerUID"])
                                                    .snapshots(),
                                                builder: (context, snapshoted) {
                                                  if (!snapshoted.hasData ||
                                                      !snapshoted
                                                          .data!.exists) {
                                                    return CircularProgressIndicator();
                                                  } else {
                                                    String? sentence =
                                                        toBeginningOfSentenceCase(
                                                            AESCryptography()
                                                                .decryptAES(enc
                                                                        .Encrypted
                                                                    .from64(snapshoted
                                                                        .data!
                                                                        .get(
                                                                            ("gender")))));
                                                    return FadeAnimation(
                                                      0.13,
                                                      volunteersName(
                                                          name: AESCryptography()
                                                              .decryptAES(enc
                                                                      .Encrypted
                                                                  .fromBase64(
                                                                      snapshoted
                                                                          .data!
                                                                          .get(
                                                                              "fullname"))),
                                                          gender: sentence!),
                                                    );
                                                  }
                                                }),
                                          ]),
                                        );
                                      }).toList()),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  StreamBuilder<DocumentSnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('campaigns')
                                          .doc(widget.uidOfCampaign)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return LinearProgressIndicator();
                                        } else {
                                          DateFormat dateFormat =
                                              DateFormat("yyyy-MM-dd");

                                          DateTime dateTime = dateFormat.parse(
                                              snapshot.data!.get('date_start'));

                                          return Text(
                                              'The Campaign will start in ' +
                                                  DateFormat.MMMM()
                                                      .format(DateTime(
                                                          dateTime.year,
                                                          dateTime.month,
                                                          dateTime.day))
                                                      .toString() +
                                                  ' ' +
                                                  dateTime.day.toString() +
                                                  ', ' +
                                                  dateTime.year.toString());
                                        }
                                      }),
                                  SizedBox(height: 30),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          HeroDialogRoute(builder: (context) {
                                        return leaveCampaign();
                                      }));
                                    },
                                    child: FadeAnimation(
                                      0.15,
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.exit_to_app,
                                            color: Colors.red,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Leave campaign",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15,
                                                color: Colors.red),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ]);
                          }
                        }),
                  ]),
            ),
          ]),
    );
  }

  Widget volunteersName({required String name, required String gender}) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(0),
          height: 70,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(2.5))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                          Text(
                            gender,
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                                fontSize: 13),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          child: Divider(
            height: 5,
            thickness: 1.5,
          ),
        )
      ],
    );
  }

  Widget leaveCampaign() {
    return Dialog(
        child: Container(
      padding: const EdgeInsets.all(15),
      height: 150,
      width: 150,
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Are you sure?",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "This action cannot be undone, if you proceed.",
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.black.withOpacity(0.8),
                    fontSize: 15),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () async {
                    try {
                      Navigator.pop(context);
                      await context.read(authserviceProvider).leaveCampaign(
                          widget.uidOfCampaign,
                          context
                              .read(authserviceProvider)
                              .getCurrentUserUID());

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LayoutScreen()));

                      Fluttertoast.showToast(msg: "You left the campaign");
                    } catch (e) {
                      print(e.toString());
                    }
                  },
                  child: Text(
                    "Yes",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                ),
                SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "No",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    ));
  }
}
