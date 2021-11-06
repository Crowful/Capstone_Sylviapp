import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sylviapp_project/Domain/aes_cryptography.dart';
import 'package:encrypt/encrypt.dart' as enc;

class CampaignMonitorOrganizer extends StatefulWidget {
  String uidOfCampaign;
  CampaignMonitorOrganizer({Key? key, required this.uidOfCampaign})
      : super(key: key);

  @override
  _CampaignMonitorOrganizerState createState() =>
      _CampaignMonitorOrganizerState();
}

class _CampaignMonitorOrganizerState extends State<CampaignMonitorOrganizer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.97),
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
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 300, 80),
                      child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back, size: 35)),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                      child: Text("ORGANIZER SCREEN",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.w900)),
                    ),
                    Text("VOLUNTEERS JOINED: "),
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
                      child: Card(
                        elevation: 3.0,
                        color: Colors.white,
                        child: Container(
                          height: 400,
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
                                      if (!snapshoted.hasData) {
                                        return CircularProgressIndicator();
                                      } else {
                                        return SingleChildScrollView(
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Column(children: [
                                                  Text(
                                                      AESCryptography().decryptAES(enc
                                                              .Encrypted
                                                          .fromBase64(snapshoted
                                                              .data!
                                                              .get(
                                                                  "fullname"))),
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(
                                                      AESCryptography().decryptAES(enc
                                                              .Encrypted
                                                          .fromBase64(snapshoted
                                                              .data!
                                                              .get(
                                                                  "phoneNumber"))),
                                                      style: TextStyle(
                                                          color:
                                                              Colors.black54)),
                                                ]),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            primary: Colors
                                                                .lightGreen),
                                                    onPressed: () {},
                                                    child: Text("View Medical"))
                                              ]),
                                        );
                                      }
                                    }),
                              ]),
                            );
                          }).toList()),
                        ),
                      ),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.blueAccent),
                              onPressed: () {},
                              child: Text("Set Start Date")),
                          SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.blueAccent),
                              onPressed: () {},
                              child: Text("Cancel Campaign")),
                          SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.blueAccent),
                              onPressed: () {},
                              child: Text("Announce")),
                        ])
                  ]);
            }
          }),
    );
  }
}
