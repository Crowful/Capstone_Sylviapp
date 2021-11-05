import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sylviapp_project/Domain/aes_cryptography.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:sylviapp_project/screens/layout_screen.dart';

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
      body: StreamBuilder<QuerySnapshot>(
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("VOLUNTEERS JOINED: "),
                    Container(
                      color: Colors.green,
                      height: 200,
                      width: 200,
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
                                  if (!snapshoted.hasData) {
                                    return CircularProgressIndicator();
                                  } else {
                                    return Column(children: [
                                      Text(AESCryptography().decryptAES(
                                          enc.Encrypted.fromBase64(snapshoted
                                              .data!
                                              .get("fullname")))),
                                    ]);
                                  }
                                }),
                            ElevatedButton(
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LayoutScreen())),
                                child: Text("Home"))
                          ]),
                        );
                      }).toList()),
                    ),
                  ]);
            }
          }),
    );
  }
}
