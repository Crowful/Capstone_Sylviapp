import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sylviapp_project/Domain/aes_cryptography.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:sylviapp_project/providers/providers.dart';
import 'package:sylviapp_project/screens/layout_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    return Scaffold(
      body: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                              return Text(AESCryptography().decryptAES(
                                  enc.Encrypted.fromBase64(
                                      snapshoteds.data!.get('fullname'))));
                            }
                          });
                    }
                  }),
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
                      return Column(children: [
                        Text("VOLUNTEERS JOINED: "),
                        Card(
                          elevation: 5.0,
                          child: Container(
                            height: 200,
                            width: 400,
                            child: ListView(
                                children: snapshot.data!.docs.map((e) {
                              return GestureDetector(
                                onTap: () {},
                                child: Column(children: [
                                  StreamBuilder<DocumentSnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(e["volunteerUID"])
                                          .snapshots(),
                                      builder: (context, snapshoted) {
                                        if (!snapshoted.hasData ||
                                            !snapshoted.data!.exists) {
                                          return CircularProgressIndicator();
                                        } else {
                                          return Column(children: [
                                            Text(AESCryptography().decryptAES(
                                                enc.Encrypted.fromBase64(
                                                    snapshoted.data!
                                                        .get("fullname")))),
                                          ]);
                                        }
                                      }),
                                ]),
                              );
                            }).toList()),
                          ),
                        ),
                        Container(
                          height: 100,
                          width: 200,
                          child: Card(
                            elevation: 5.0,
                            child: Center(child: Text("ANNOUNCEMENT")),
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LayoutScreen())),
                            child: Text("Home")),
                        ElevatedButton(
                            onPressed: () async {
                              try {
                                await context
                                    .read(authserviceProvider)
                                    .leaveCampaign(
                                        widget.uidOfCampaign,
                                        context
                                            .read(authserviceProvider)
                                            .getCurrentUserUID());

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LayoutScreen()));

                                Fluttertoast.showToast(
                                    msg: "You left the campaign");
                              } catch (e) {
                                print(e.toString());
                              }
                            },
                            child: Text("Leave on this campaign"))
                      ]);
                    }
                  }),
            ]),
      ),
    );
  }
}
