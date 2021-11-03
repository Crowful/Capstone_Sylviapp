import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:sylviapp_project/screens/campaign_module/volunteer_form.dart';

class JoinDonateCampaign extends StatefulWidget {
  final String? uidOfCampaign;
  final String? address;
  final String? description;
  final String? uidOfOrganizer;
  const JoinDonateCampaign(
      {Key? key,
      this.uidOfCampaign,
      this.address,
      this.description,
      this.uidOfOrganizer})
      : super(key: key);

  @override
  _JoinDonateCampaignState createState() => _JoinDonateCampaignState();
}

class _JoinDonateCampaignState extends State<JoinDonateCampaign> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white.withOpacity(0.97),
        body: Center(
          child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("campaigns")
                  .doc(widget.uidOfCampaign)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                } else {
                  return Stack(fit: StackFit.expand, children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 462.5),
                      height: 300,
                      width: 350,
                      child: Image.network(
                          "https://images.unsplash.com/photo-1425913397330-cf8af2ff40a1?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1374&q=80"),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(30, 230, 30, 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      width: 320,
                      height: 400,
                      child: Column(
                        children: [
                          Container(
                              child: Column(children: [
                            Row(children: [
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 300,
                                      margin: EdgeInsets.fromLTRB(20, 20, 0, 0),
                                      child: Text(
                                        "Angat Campaign",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 25,
                                            fontWeight: FontWeight.w900),
                                      ),
                                    ),
                                    Container(
                                        width: 150,
                                        margin:
                                            EdgeInsets.fromLTRB(20, 5, 0, 0),
                                        child: Text(
                                          "Tagaytay City",
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 11),
                                        )),
                                  ]),
                            ]),
                          ])),
                          Container(
                            margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
                            child: Text(
                                "I'm Alfie Tribaco the organizer of this campaign and I would like to make this campaign success as possible, come and join to this campaign and make our nature be better again.",
                                style: TextStyle(color: Colors.black54)),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(children: [
                                    Text(
                                      "23/50",
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w900),
                                    ),
                                    Text("Volunteers",
                                        style: TextStyle(color: Colors.black54))
                                  ]),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Column(children: [
                                    Text(
                                      " ₱1400",
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w900),
                                    ),
                                    Text("Fund Needed",
                                        style: TextStyle(color: Colors.black54))
                                  ]),
                                ]),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 120,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.orange,
                                          shape: StadiumBorder(
                                              side: BorderSide(
                                                  width: 1,
                                                  color: Colors.orange))),
                                      onPressed: () async {
                                        var request = BraintreeDropInRequest(
                                            tokenizationKey:
                                                'sandbox_mf5kvmgw_mhmfxcfrgwwftpcq',
                                            collectDeviceData: true,
                                            paypalRequest:
                                                BraintreePayPalRequest(
                                              amount: '10.00',
                                              displayName: 'SylviaApp',
                                            ),
                                            cardEnabled: true);

                                        BraintreeDropInResult? result =
                                            await BraintreeDropIn.start(
                                                request);

                                        if (result != null) {
                                          print(result
                                              .paymentMethodNonce.description);
                                          print(
                                              result.paymentMethodNonce.nonce);
                                        } else {
                                          print("FAILED PAYMENT PROCESS");
                                        }
                                      },
                                      child: Text(
                                        "D O N A T E",
                                        style: TextStyle(color: Colors.white),
                                      )),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  width: 120,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Color(0xff65BFB8),
                                          shape: StadiumBorder()),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    VolunteerFormScreen()));
                                      },
                                      child: Text("J O I N ")),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(50, 600, 50, 20),
                      width: 200,
                      height: 200,
                      color: Colors.white54,
                      child: ExpansionTile(
                        backgroundColor: Colors.white54,
                        title: Text("Terms And Conditions"),
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "This is the Terms and Conditions that should be followed by the volunteer, during and after the campaign."),
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 330, 680),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                    )
                  ]);
                }
              }),
        ),
      ),
    );
  }
}
