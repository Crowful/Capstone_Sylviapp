import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sylviapp_project/Domain/aes_cryptography.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:sylviapp_project/animation/FadeAnimation.dart';
import 'package:sylviapp_project/animation/pop_up.dart';
import 'package:sylviapp_project/providers/providers.dart';
import 'package:sylviapp_project/screens/layout_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height - 670,
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
                                              image: AssetImage(
                                                  "assets/images/userpass.png"))),
                                    ),
                                  ),
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
                                                icon: Icon(Icons.arrow_back)),
                                            Text(
                                              campaignName,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
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
                                                return StreamBuilder<
                                                        DocumentSnapshot>(
                                                    stream: FirebaseFirestore
                                                        .instance
                                                        .collection('users')
                                                        .doc(snapshot.data!
                                                            .get('uid'))
                                                        .snapshots(),
                                                    builder:
                                                        (context, snapshoteds) {
                                                      if (!snapshoteds
                                                          .hasData) {
                                                        return CircularProgressIndicator();
                                                      } else {
                                                        return Container(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  20),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              FadeAnimation(
                                                                0.1,
                                                                Text(
                                                                  "Hello, " +
                                                                      AESCryptography().decryptAES(enc.Encrypted.fromBase64(snapshoteds
                                                                          .data!
                                                                          .get(
                                                                              'fullname'))),
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          18),
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
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontSize:
                                                                          13),
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
                                    height: 10,
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                FadeAnimation(
                                                  0.5,
                                                  Text(
                                                    "Announcement",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff65BFB8),
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height -
                                                            670,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5)),
                                                        color: Colors.grey
                                                            .withOpacity(0.35)),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        StreamBuilder<
                                                                DocumentSnapshot>(
                                                            stream: FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "campaigns")
                                                                .doc(widget
                                                                    .uidOfCampaign)
                                                                .collection(
                                                                    "announcement")
                                                                .doc(
                                                                    'announcement')
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
                                                                      .data!
                                                                      .exists) {
                                                                return Text(
                                                                    snapshotAnnouncement
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
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 17),
                                                  ),
                                                ),
                                                FadeAnimation(
                                                  0.11,
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    height: 360,
                                                    decoration: BoxDecoration(
                                                        color: Colors.grey
                                                            .withOpacity(0.25)),
                                                    child: ListView(
                                                        children: snapshot
                                                            .data!.docs
                                                            .map((e) {
                                                      return GestureDetector(
                                                        onTap: () {},
                                                        child: Column(
                                                            children: [
                                                              StreamBuilder<
                                                                      DocumentSnapshot>(
                                                                  stream: FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          "users")
                                                                      .doc(e[
                                                                          "volunteerUID"])
                                                                      .snapshots(),
                                                                  builder: (context,
                                                                      snapshoted) {
                                                                    if (!snapshoted
                                                                            .hasData ||
                                                                        !snapshoted
                                                                            .data!
                                                                            .exists) {
                                                                      return CircularProgressIndicator();
                                                                    } else {
                                                                      String?
                                                                          sentence =
                                                                          toBeginningOfSentenceCase(AESCryptography().decryptAES(enc.Encrypted.from64(snapshoted
                                                                              .data!
                                                                              .get(("gender")))));
                                                                      return FadeAnimation(
                                                                        0.13,
                                                                        volunteersName(
                                                                            name:
                                                                                AESCryptography().decryptAES(enc.Encrypted.fromBase64(snapshoted.data!.get("fullname"))),
                                                                            gender: sentence!),
                                                                      );
                                                                    }
                                                                  }),
                                                            ]),
                                                      );
                                                    }).toList()),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                        HeroDialogRoute(
                                                            builder: (context) {
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
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ]);
                                        }
                                      }),
                                ],
                              ),
                            ),
                          ]),
                    ),
                  );
                }
              }),
        );
      }),
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
