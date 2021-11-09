import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sylviapp_project/Domain/aes_cryptography.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:intl/intl.dart';
import 'package:sylviapp_project/animation/FadeAnimation.dart';
import 'package:sylviapp_project/animation/pop_up.dart';
import 'package:sylviapp_project/screens/campaign_module/showVolunteer.dart';
import 'package:transparent_image/transparent_image.dart';

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

  Future showProfile(uid) async {
    String fileName = "pic";
    String destination = 'files/users/$uid/ProfilePicture/$fileName';
    Reference firebaseStorageRef = FirebaseStorage.instance.ref(destination);
    try {
      taske2 = await firebaseStorageRef.getDownloadURL();
    } catch (e) {
      setState(() {
        errorText2 = e.toString();
      });
    }
    if (this.mounted) {
      setState(() {
        urlTest2 = taske2.toString();
      });
    }
  }

  bool isOpened = false;
  late AnimationController _animationController = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 400),
  );
  @override
  void initState() {
    super.initState();
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

  late List<String?> imgLinks = [''];
  showNow() {
    for (var i in imgLinks) {
      showProfile(i.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
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
                          var campaignName =
                              snapshotCampaign.data?.get("campaign_name");
                          var orgName = snapshotCampaign.data?.get("uid");
                          return Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 130,
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
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  IconButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      icon: Icon(
                                                          Icons.arrow_back)),
                                                  Text(
                                                    campaignName,
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                ],
                                              ),
                                              StreamBuilder<DocumentSnapshot>(
                                                  stream: FirebaseFirestore
                                                      .instance
                                                      .collection("campaigns")
                                                      .doc(widget.uidOfCampaign)
                                                      .snapshots(),
                                                  builder: (context, snapshot) {
                                                    if (!snapshot.hasData) {
                                                      return CircularProgressIndicator();
                                                    } else {
                                                      return StreamBuilder<
                                                              DocumentSnapshot>(
                                                          stream:
                                                              FirebaseFirestore
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
                                                                      EdgeInsets
                                                                          .all(
                                                                              15),
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        "Hello, Organizer",
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .headline1,
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                      Text(
                                                                        "Manage the volunteers for your upcoming campaign, organizer.",
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .headline2,
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
                                                fontWeight: FontWeight.w600),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5))),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: ListView(
                                                  children: snapshotVolunteers
                                                      .data!.docs
                                                      .map((e) {
                                                return StreamBuilder<
                                                        DocumentSnapshot>(
                                                    stream: FirebaseFirestore
                                                        .instance
                                                        .collection('users')
                                                        .doc(e["volunteerUID"])
                                                        .snapshots(),
                                                    builder: (context,
                                                        snapshotList) {
                                                      imgLinks.add(snapshotList
                                                          .data?.id);
                                                      String? sentence =
                                                          toBeginningOfSentenceCase(
                                                              AESCryptography()
                                                                  .decryptAES(enc
                                                                          .Encrypted
                                                                      .from64(snapshotList
                                                                          .data!
                                                                          .get(
                                                                              ("gender")))));
                                                      if (!snapshotList
                                                          .hasData) {
                                                        return CircularProgressIndicator();
                                                      }
                                                      return FadeAnimation(
                                                        0.7,
                                                        volunteerWidget(
                                                            imgLink:
                                                                snapshotList
                                                                    .data!.id,
                                                            orgID: orgName,
                                                            uid: snapshotList
                                                                .data!.id,
                                                            name: AESCryptography()
                                                                .decryptAES(enc
                                                                        .Encrypted
                                                                    .from64(snapshotList
                                                                        .data!
                                                                        .get(
                                                                            "fullname"))),
                                                            gender: sentence!),
                                                      );
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
                            ),
                          );
                        });
                  }
                }),
            AnimatedPositioned(
              top: isOpened ? 730 : 520,
              duration: Duration(milliseconds: 500),
              child: FadeAnimation(
                0.9,
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
                    Container(
                      padding: const EdgeInsets.all(20),
                      height: 220,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10, spreadRadius: 5,
                              offset: Offset(0, -5), // Shadow position
                            ),
                          ]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Campaign Settings",
                            style: Theme.of(context).textTheme.headline1,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            child: Center(
                              child: Text(
                                "Set Start Date",
                              ),
                            ),
                          ),
                          ElevatedButton(
                              onPressed: () {},
                              child: Center(
                                child: Text("Announce"),
                              )),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .push(HeroDialogRoute(builder: (context) {
                                  return cancelCampaign();
                                }));
                              },
                              child: Center(
                                child: Text("Cancel Campaign"),
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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
        height: 130,
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
                    Text(
                      "Cancel",
                      style: TextStyle(fontWeight: FontWeight.w600),
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
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Color(0xff65BFB8),
                        backgroundImage: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: urlTest2,
                          imageErrorBuilder: (context, error, stackTrace) {
                            return CircularProgressIndicator();
                          },
                        ).image,
                      ),
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
                            style: Theme.of(context).textTheme.headline2,
                          ),
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
}
