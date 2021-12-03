import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sylviapp_project/Domain/aes_cryptography.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:intl/intl.dart';
import 'package:sylviapp_project/animation/FadeAnimation.dart';
import 'package:sylviapp_project/animation/pop_up.dart';
import 'package:sylviapp_project/providers/providers.dart';
import 'package:sylviapp_project/screens/campaign_module/campaign_done.dart';
import 'package:sylviapp_project/screens/campaign_module/organizer_inprogress_campaign.dart';
import 'package:sylviapp_project/screens/campaign_module/showVolunteer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: must_be_immutable
class CampaignMonitorOrganizer extends StatefulWidget {
  String uidOfCampaign;
  CampaignMonitorOrganizer({Key? key, required this.uidOfCampaign})
      : super(key: key);

  @override
  _CampaignMonitorOrganizerState createState() =>
      _CampaignMonitorOrganizerState();
}

class _CampaignMonitorOrganizerState extends State<CampaignMonitorOrganizer>
    with TickerProviderStateMixin {
  String? taske2;
  String? errorText2;
  String urlTest2 = "";
  var imgLink;

  TextEditingController announcementTextController = TextEditingController();

  Future showProfiled(uid) async {
    String fileName = "pic";
    String destination = 'files/users/$uid/ProfilePicture/$fileName';
    Reference firebaseStorageRef = FirebaseStorage.instance.ref(destination);
    try {
      taske2 = await firebaseStorageRef.getDownloadURL();
    } catch (e) {
      if (this.mounted) {
        setState(() {
          errorText2 = e.toString();
        });
      }
    }
    if (this.mounted) {
      setState(() {
        urlTest2 = taske2.toString();
      });
    }
  }

  closeControls() {
    isOpened = true;
  }

  bool isOpened = false;
  late AnimationController _animationController = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 400),
  );
  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection('campaigns')
        .doc(widget.uidOfCampaign)
        .get()
        .then((value) {
      FirebaseFirestore.instance
          .collection('campaigns')
          .doc(widget.uidOfCampaign)
          .get()
          .then((values) {
        bool yes = values.get('isCompleted');

        if (yes == false) {
          DateFormat dateFormat = DateFormat("yyyy-MM-dd");

          DateTime dateTime = dateFormat.parse(value.get('date_start'));
          if (DateTime.now().year == dateTime.year &&
              DateTime.now().month == dateTime.month &&
              DateTime.now().day == dateTime.day) {
            Navigator.of(context).push(HeroDialogRoute(builder: (context) {
              return startCampaign();
            }));
          }
        } else {
          isOpened = true;
        }
      });
    });

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        badge: true, sound: true, alert: true);

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
    FirebaseMessaging.instance.getToken().then((value) {
      print(value);
    });

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    _animationController.animateTo(1.0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
    showNow();
  }

  _handleIcon() {
    if (isOpened == true) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }

  late List<String?> imgLinks = List.empty(growable: true);
  showNow() {
    for (var i = 0; i < imgLinks.length; i++) {
      showProfiled(i.toString());
    }
  }

  bool isShow = true;

  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 15)));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("campaigns")
                      .doc(widget.uidOfCampaign)
                      .collection("volunteers")
                      .snapshots(),
                  builder: (context, snapshotVolunteers) {
                    if (!snapshotVolunteers.hasData) {
                      return CircularProgressIndicator();
                    } else {
                      return StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("campaigns")
                              .doc(widget.uidOfCampaign)
                              .snapshots(),
                          builder: (context, snapshotCampaign) {
                            if (!snapshotCampaign.hasData) {
                              return CircularProgressIndicator();
                            } else {
                              if (snapshotCampaign.data!.get('inProgress') ==
                                  true) {
                                isShow = false;
                                return InProgressCampaign(
                                    uidOfCampaign: widget.uidOfCampaign);
                              }

                              if (snapshotCampaign.data!.get('isCompleted') ==
                                  true) {
                                isShow = false;
                                return CampaignCompleted(
                                  campaignUID: widget.uidOfCampaign,
                                );
                              }
                              if (snapshotCampaign.data!.get('isActive') ==
                                  true) {
                                isShow = false;
                                var campaignName =
                                    snapshotCampaign.data?.get("campaign_name");

                                var orgName = snapshotCampaign.data?.get("uid");

                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.2,
                                      color: Color(0xff65BFB8),
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
                                                      image: AssetImage(
                                                          "assets/images/userpass.png"))),
                                            ),
                                          ),
                                          FadeAnimation(
                                            0.1,
                                            Container(
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      IconButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          icon: Icon(Icons
                                                              .arrow_back)),
                                                      Text(
                                                        campaignName,
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    ],
                                                  ),
                                                  StreamBuilder<
                                                          DocumentSnapshot>(
                                                      stream: FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              "campaigns")
                                                          .doc(widget
                                                              .uidOfCampaign)
                                                          .snapshots(),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (!snapshot.hasData) {
                                                          return CircularProgressIndicator();
                                                        } else {
                                                          return StreamBuilder<
                                                                  DocumentSnapshot>(
                                                              stream: FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'users')
                                                                  .doc(snapshot
                                                                      .data!
                                                                      .get(
                                                                          'uid'))
                                                                  .snapshots(),
                                                              builder: (context,
                                                                  snapshoteds) {
                                                                if (!snapshoteds
                                                                    .hasData) {
                                                                  return CircularProgressIndicator();
                                                                } else {
                                                                  return FadeAnimation(
                                                                    0.3,
                                                                    Container(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              15),
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            "Hello, Organizer",
                                                                            style:
                                                                                Theme.of(context).textTheme.headline1,
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                5,
                                                                          ),
                                                                          Text(
                                                                            "Manage the volunteers for your upcoming campaign, organizer.",
                                                                            style:
                                                                                Theme.of(context).textTheme.headline2,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  );
                                                                }
                                                              });
                                                        }
                                                      }),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: FadeAnimation(
                                        0.5,
                                        Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.all(20),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Manage Volunteers",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Expanded(
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5))),
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: ListView(
                                                      children:
                                                          snapshotVolunteers
                                                              .data!.docs
                                                              .map((e) {
                                                    return StreamBuilder<
                                                            DocumentSnapshot>(
                                                        stream: FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(e[
                                                                "volunteerUID"])
                                                            .snapshots(),
                                                        builder: (context,
                                                            snapshotList) {
                                                          if (!snapshotList
                                                              .hasData) {
                                                            return CircularProgressIndicator();
                                                          } else {
                                                            String? sentence = toBeginningOfSentenceCase(
                                                                AESCryptography().decryptAES(enc
                                                                        .Encrypted
                                                                    .from64(snapshotList
                                                                        .data!
                                                                        .get(
                                                                            ("gender")))));
                                                            return FadeAnimation(
                                                              0.7,
                                                              volunteerWidget(
                                                                  number: AESCryptography().decryptAES(enc.Encrypted.from64(
                                                                      snapshotList
                                                                          .data!
                                                                          .get(
                                                                              "phoneNumber"))),
                                                                  imgLink:
                                                                      snapshotList
                                                                          .data!
                                                                          .id,
                                                                  orgID:
                                                                      orgName,
                                                                  uid: e.id,
                                                                  name: AESCryptography()
                                                                      .decryptAES(enc.Encrypted.from64(snapshotList
                                                                          .data!
                                                                          .get(
                                                                              "fullname"))),
                                                                  gender:
                                                                      sentence!),
                                                            );
                                                          }
                                                        });
                                                  }).toList()),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return Center(
                                  child: Text('Something went wrong'),
                                );
                              }
                            }
                          });
                    }
                  }),
              AnimatedPositioned(
                top: isOpened
                    ? MediaQuery.of(context).size.height - 80
                    : MediaQuery.of(context).size.height - 350,
                duration: Duration(milliseconds: 500),
                child: FadeAnimation(
                  0.2,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10))),
                        padding: const EdgeInsets.all(20),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isOpened = !isOpened;
                              _handleIcon();
                            });
                          },
                          child: Align(
                            alignment: Alignment.topRight,
                            child: AnimatedIcon(
                              progress: _animationController,
                              icon: AnimatedIcons.menu_close,
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                      StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('quarantineStatus')
                              .doc('status')
                              .snapshots(),
                          builder: (context, snapshotStatus) {
                            if (!snapshotStatus.hasData) {
                              return Center(child: CircularProgressIndicator());
                            } else {
                              print(isOpened);
                              var status = snapshotStatus.data!.get('status');
                              return StreamBuilder<DocumentSnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('campaigns')
                                      .doc(widget.uidOfCampaign)
                                      .snapshots(),
                                  builder: (context, snapshotCompleted) {
                                    if (!snapshotCompleted.hasData) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    } else {
                                      bool done = snapshotCompleted.data!
                                          .get('isCompleted');
                                      return AbsorbPointer(
                                        absorbing: done ? true : false,
                                        child: Container(
                                          padding: const EdgeInsets.all(20),
                                          height: 400,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            color: Color(0xff65BFB8),
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20)),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Campaign Settings",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline1,
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              ElevatedButton(
                                                onPressed: () =>
                                                    _selectDate(context)
                                                        .whenComplete(() {
                                                  context
                                                      .read(authserviceProvider)
                                                      .setStartingDate(
                                                          widget.uidOfCampaign,
                                                          selectedDate
                                                              .toString());
                                                }),
                                                child: Center(
                                                  child: Text(
                                                    "Set Start Date",
                                                  ),
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  if (status == "ECQ" ||
                                                      status == "MECQ" ||
                                                      status == "GCQ") {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "The area is still in lockdown, please wait until the lockdown is lifted.");
                                                  } else {
                                                    setState(() {
                                                      isOpened = !isOpened;
                                                    });
                                                    context
                                                        .read(
                                                            authserviceProvider)
                                                        .startTheCampaign(widget
                                                            .uidOfCampaign);
                                                  }
                                                },
                                                child: Center(
                                                  child: Text(
                                                    "Start The Campaign now",
                                                  ),
                                                ),
                                              ),
                                              ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).push(
                                                        HeroDialogRoute(
                                                            builder: (context) {
                                                      return postAnnouncement();
                                                    }));
                                                  },
                                                  child: Center(
                                                    child: Text("Announce"),
                                                  )),
                                              ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).push(
                                                        HeroDialogRoute(
                                                            builder: (context) {
                                                      return Container(
                                                          margin: EdgeInsets
                                                              .fromLTRB(20, 200,
                                                                  20, 400),
                                                          child:
                                                              cancelCampaign());
                                                    }));
                                                  },
                                                  child: Center(
                                                    child:
                                                        Text("Cancel Campaign"),
                                                  ))
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                  });
                            }
                          }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget cancelCampaign({Widget? buttonYes, Widget? buttonNo}) {
    return Dialog(
      insetAnimationCurve: Curves.fastOutSlowIn,
      insetAnimationDuration: Duration(milliseconds: 500),
      elevation: 3,
      child: Container(
        padding: const EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height,
        width: 200,
        child: Stack(
          children: [
            Column(
              children: [
                Text(
                  "Are you sure?",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Deleting this will send a request in admin.",
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                      fontSize: 13),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        onPressed: () async {},
                        child: Center(
                          child: Text(
                            "Yes",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        )),
                    SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget volunteerWidget(
      {required String name,
      required String gender,
      required String uid,
      required String number,
      required String imgLink,
      required String orgID}) {
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 200,
                            child: Text(
                              name,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(children: [
                            Text(
                              gender,
                              style: Theme.of(context).textTheme.headline2,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              number,
                              style: Theme.of(context).textTheme.headline2,
                            ),
                          ]),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .push(HeroDialogRoute(builder: (context) {
                    return ShowVolunteer(
                      campaignID: widget.uidOfCampaign,
                      organizerID: orgID,
                      userID: uid,
                    );
                  }));
                },
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Color(0xff65BFB8),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Center(
                    child: Text(
                      "View Details",
                      style: TextStyle(fontSize: 13, color: Colors.white),
                    ),
                  ),
                ),
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

  Widget postAnnouncement() {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(20),
        height: 350,
        width: double.infinity,
        decoration:
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(40))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Post Announcement',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            Text(
              'Type what you have to say to your volunteers.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
                child: Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.grey.withOpacity(0.2)),
              child: TextField(
                controller: announcementTextController,
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 10,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
              ),
            )),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () async {
                await context.read(authserviceProvider).addAnnouncement(
                    widget.uidOfCampaign, announcementTextController.text);

                announcementTextController.clear();

                Navigator.pop(context);
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Color(0xff65BFB8)),
                child: Center(
                  child: Text('Post'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget startCampaign() {
    return Dialog(
      child: IntrinsicHeight(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reminder!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                  'This is the day you set your campaign to be started, click start campaign.'),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  context
                      .read(authserviceProvider)
                      .startTheCampaign(widget.uidOfCampaign);
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                      color: Color(0xff65BFB8)),
                  child: Center(
                    child: Text(
                      "Start The Campaign now",
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
